module User.State exposing
  ( emptyCollection
  , emptyUser
  , emptyLoopCmd
  , playLoop
  , stopLoop
  )


import Dict

import Loop.State
import Loop.Types

import User.Types exposing (..)


emptyCollection : Collection
emptyCollection =
  Dict.empty


emptyUser : Model
emptyUser =
  let
    (loop, loopCmds) = Loop.State.initialState "Empty Loop"
  in
    Model "Empty User" loop


emptyLoopCmd : LoopCmd
emptyLoopCmd =
  LoopCmd "Empty User" Cmd.none


playLoop : Model -> Cmd Loop.Types.Msg
playLoop user =
  Loop.State.play user.loop


stopLoop : Model -> Cmd Loop.Types.Msg
stopLoop user =
  Loop.State.stop user.loop
