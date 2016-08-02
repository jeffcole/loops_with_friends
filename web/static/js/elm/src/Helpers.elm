module Helpers exposing (..)


import Dict exposing (Dict)

import Types exposing (..)

import Loop.Types
import User.State
import User.Types


playerUser : Model -> User.Types.Model
playerUser model =
  getUser model.userId model.users


playerLoop : Model -> Loop.Types.Model
playerLoop model =
  .loop (playerUser model)


playerLoopName : Model -> String
playerLoopName model =
  .name (playerLoop model)

playerLoopState : Model -> Loop.Types.State
playerLoopState model =
  .state (playerLoop model)


getUser : User.Types.ID -> User.Types.Collection -> User.Types.Model
getUser userId users =
  Dict.get userId users
  |> Maybe.withDefault User.State.emptyUser


otherUsers : Model -> User.Types.Collection
otherUsers model =
  model.users
  |> Dict.filter (\userId user -> userId /= model.userId)


updateUser : User.Types.Model -> User.Types.Collection -> User.Types.Collection
updateUser user users =
  users
  |> Dict.remove user.id
  |> Dict.insert user.id user


tagUserCmds : User.Types.LoopCmd -> Cmd Msg
tagUserCmds cmd =
  Cmd.map (UserMsg cmd.userId) cmd.cmds


identityDict : (a -> comparable) -> List a -> Dict comparable a
identityDict idFunction list =
  List.map (\item -> (idFunction item, item)) list
  |> Dict.fromList
