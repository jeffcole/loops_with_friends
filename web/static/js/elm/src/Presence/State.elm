module Presence.State exposing (updatePresenceState, updatePresenceDiff)


import Debug
import Dict
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

import Lib.Helpers
import Loop.State
import User.State
import User.Types

import Presence.Types exposing (..)


updatePresenceState
  :  PresenceState UserPresence
  -> Json.Encode.Value
  -> (User.Types.Collection, PresenceState UserPresence, List User.Types.LoopCmd)
updatePresenceState presences json =
  case decodePresenceState json of
    Ok presenceState ->
      let
        newPresenceState = syncState presences presenceState
        (users, cmds) =
          presenceStateToUserPresences newPresenceState
          |> usersAndCmds User.Types.emptyCollection
      in
        (users, newPresenceState, cmds)
    Err error ->
      let
        _ = Debug.log "Error" error
      in
        (User.Types.emptyCollection, presences, [User.Types.emptyLoopCmd])


updatePresenceDiff
  :  User.Types.Collection
  -> PresenceState UserPresence
  -> Json.Encode.Value
  -> (User.Types.Collection, PresenceState UserPresence, List User.Types.LoopCmd)
updatePresenceDiff users presences json =
  case decodePresenceDiff json of
    Ok presenceDiff ->
      let
        newPresenceState = syncDiff presences presenceDiff
        (users, cmds) =
          presenceStateToUserPresences newPresenceState
          |> usersAndCmds users
      in
        (users, newPresenceState, cmds)
    Err error ->
      let
        _ = Debug.log "Error" error
      in
        (User.Types.emptyCollection, presences, [User.Types.emptyLoopCmd])


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


presenceStateToUserPresences : PresenceState UserPresence -> List UserPresence
presenceStateToUserPresences presenceState =
  presenceState
  |> Phoenix.Presence.list mostRecent
  |> List.filterMap identity
  |> List.map toUserPresence


usersAndCmds
  :  User.Types.Collection
  -> List UserPresence
  -> (User.Types.Collection, List User.Types.LoopCmd)
usersAndCmds users userPresences =
  let
    existingUsersAndCmds =
      Dict.filter (presenceIn userPresences) users
      |> Dict.values
      |> List.map (\user -> (user, User.Types.LoopCmd user.id Cmd.none))
    newUsersAndCmds =
      List.filter (presenceNotIn users) userPresences
      |> List.map toUserAndCmds
    (updatedUsers, cmds) =
      List.append existingUsersAndCmds newUsersAndCmds
      |> List.unzip
  in
    (Lib.Helpers.identityDict .id updatedUsers, cmds)


presenceIn : List UserPresence -> User.Types.ID -> User.Types.Model -> Bool
presenceIn userPresences userId user =
  List.any (\presence -> presence.userId == userId) userPresences


presenceNotIn : User.Types.Collection -> UserPresence -> Bool
presenceNotIn users presence =
  not (Dict.member presence.userId users)


mostRecent
  :  String
  -> PresenceStateMetaWrapper UserPresence
  -> Maybe (PresenceStateMetaValue UserPresence)
mostRecent key wrapper =
  List.head wrapper.metas


toUserPresence : PresenceStateMetaValue UserPresence -> UserPresence
toUserPresence value =
  value.payload


toUserAndCmds
  : UserPresence -> (User.Types.Model, User.Types.LoopCmd)
toUserAndCmds userPresence =
  let
    (loop, loopCmds) = Loop.State.initialState userPresence.loopName
    user = User.Types.Model userPresence.userId loop
  in
    (user, User.Types.LoopCmd user.id loopCmds)


userPresenceDecoder : JD.Decoder UserPresence
userPresenceDecoder =
  JDP.decode UserPresence
    |> JDP.required "user_id" JD.string
    |> JDP.required "loop_name" JD.string
