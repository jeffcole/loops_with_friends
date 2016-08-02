module Helpers exposing (..)


import Dict

import Types exposing (..)

import User.Helpers
import User.Types


playerUser : Model -> User.Types.Model
playerUser model =
  User.Helpers.getUser model.userId model.users


otherUsers : Model -> User.Types.Collection
otherUsers model =
  model.users
  |> Dict.filter (\userId user -> userId /= model.userId)


tagUserCmds : User.Types.LoopCmd -> Cmd Msg
tagUserCmds cmd =
  Cmd.map (UserMsg cmd.userId) cmd.cmds
