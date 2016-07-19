module Presence.State exposing (updatePresenceState, updatePresenceDiff)


import Debug
import Dict exposing (Dict)
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
import Loop.State
import Loop.Types
import User.Types


updatePresenceState
  :  PresenceState UserPresence
  -> Json.Encode.Value
  -> (User.Types.Collection, PresenceState UserPresence, Cmd Loop.Types.Msg)
updatePresenceState presences json =
  case decodePresenceState json of
    Ok presenceState ->
      let
        newPresenceState = syncState presences presenceState
        (users, cmds) = presenceStateToUsersAndCmds newPresenceState
      in
        (users, newPresenceState, cmds)
    Err error ->
      let
        _ = Debug.log "Error" error
      in
        (Dict.empty, presences, Cmd.none)


updatePresenceDiff
  :  PresenceState UserPresence
  -> Json.Encode.Value
  -> (User.Types.Collection, PresenceState UserPresence)
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
        (Dict.empty, presences)


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


presenceStateToUsersAndCmds
  :  PresenceState UserPresence
  -> (User.Types.Collection, Cmd Loop.Types.Msg)
presenceStateToUsersAndCmds presenceState =
  let
    (userAssociations, cmds) =
      presenceState
      |> Phoenix.Presence.list mostRecent
      |> List.filterMap identity
      |> List.map toUserPresence
      |> List.map toUserAssociationAndCmds
      |> List.unzip
    users = Dict.fromList userAssociations
  in
    (users, Cmd.batch cmds)


presenceStateToUsers
  : PresenceState UserPresence -> User.Types.Collection
presenceStateToUsers presenceState =
  presenceState
  |> Phoenix.Presence.list mostRecent
  |> List.filterMap identity
  |> List.map toUserPresence
  |> List.map toUserAssociation
  |> Dict.fromList


mostRecent
  :  String
  -> PresenceStateMetaWrapper UserPresence
  -> Maybe (PresenceStateMetaValue UserPresence)
mostRecent key wrapper =
  List.head wrapper.metas


toUserPresence : PresenceStateMetaValue UserPresence -> UserPresence
toUserPresence value =
  value.payload


toUserAssociationAndCmds
  : UserPresence -> ((User.Types.ID, User.Types.Model), Cmd Loop.Types.Msg)
toUserAssociationAndCmds userPresence =
  let
    (loop, loopCmds) = Loop.State.initialState userPresence.loopName
    user = User.Types.Model userPresence.userId userPresence.loopName loop
    userAssociation = (user.id, user)
  in
    (userAssociation, loopCmds)


toUserAssociation : UserPresence -> (User.Types.ID, User.Types.Model)
toUserAssociation userPresence =
  let
    (loop, loopCmds) = Loop.State.initialState userPresence.loopName
    user = User.Types.Model userPresence.userId userPresence.loopName loop
  in
    (user.id, user)


userPresenceDecoder : JD.Decoder UserPresence
userPresenceDecoder =
  JDP.decode UserPresence
    |> JDP.required "user_id" JD.string
    |> JDP.required "loop_name" JD.string
