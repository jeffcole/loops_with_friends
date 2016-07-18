module Presence.State exposing (updatePresenceState, updatePresenceDiff)


import Debug
import Json.Encode
import Json.Decode as JD exposing ((:=))
import Json.Decode.Pipeline as JDP

import Phoenix.Presence exposing
  ( PresenceDiff
  , PresenceState
  , PresenceStateMetaWrapper
  , PresenceStateMetaValue
  , presenceDiffDecoder
  , presenceStateDecoder
  )

import Presence.Types exposing (..)
import User.Types


updatePresenceState
  :  PresenceState UserPresence
  -> Json.Encode.Value
  -> (List User.Types.Model, PresenceState UserPresence)
updatePresenceState presences json =
  case decodePresenceState json of
    Ok presenceState ->
      let
        newPresenceState = syncState presences presenceState
        users = presenceStateToUsers newPresenceState
      in
        (users, newPresenceState)
    Err error ->
      let
        _ = Debug.log "Error" error
      in
        ([], presences)


updatePresenceDiff
  :  PresenceState UserPresence
  -> Json.Encode.Value
  -> (List User.Types.Model, PresenceState UserPresence)
updatePresenceDiff presences json =
  case decodePresenceDiff json of
    Ok presenceDiff ->
      let
        newPresenceState = syncDiff presences presenceDiff
        users = presenceStateToUsers newPresenceState
      in
        (users, newPresenceState)
    Err error ->
        let
          _ = Debug.log "Error" error
        in
          ([], presences)


decodePresenceState
  : Json.Encode.Value -> Result String (PresenceState UserPresence)
decodePresenceState json =
  JD.decodeValue (presenceStateDecoder userPresenceDecoder) json


decodePresenceDiff
  : Json.Encode.Value -> Result String (PresenceDiff UserPresence)
decodePresenceDiff json =
  JD.decodeValue (presenceDiffDecoder userPresenceDecoder) json


syncState
  :  PresenceState UserPresence
  -> PresenceState UserPresence
  -> PresenceState UserPresence
syncState presences presenceState =
  presences
  |> Phoenix.Presence.syncState presenceState


syncDiff
  :  PresenceState UserPresence
  -> PresenceDiff UserPresence
  -> PresenceState UserPresence
syncDiff presences presenceDiff =
  presences
  |> Phoenix.Presence.syncDiff presenceDiff


presenceStateToUsers : PresenceState UserPresence -> List User.Types.Model
presenceStateToUsers presenceState =
  presenceState
  |> Phoenix.Presence.list mostRecent
  |> List.filterMap identity
  |> List.map toUserPresence
  |> List.map toUser


mostRecent
  :  String
  -> PresenceStateMetaWrapper UserPresence
  -> Maybe (PresenceStateMetaValue UserPresence)
mostRecent key wrapper =
  List.head wrapper.metas


toUserPresence : PresenceStateMetaValue UserPresence -> UserPresence
toUserPresence value =
  value.payload


toUser : UserPresence -> User.Types.Model
toUser userPresence =
  User.Types.Model userPresence.userId userPresence.loopName


userPresenceDecoder : JD.Decoder UserPresence
userPresenceDecoder =
    JDP.decode UserPresence
      |> JDP.required "user_id" JD.string
      |> JDP.required "loop_name" JD.string
