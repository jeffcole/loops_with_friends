module User.State exposing (empty, playLoop, stopLoop)


import Loop.State
import Loop.Types

import User.Types exposing (..)


empty : Model
empty =
  let
    (loop, loopCmds) = Loop.State.initialState "Empty Loop"
  in
    Model "Empty User" loop


playLoop : Model -> Cmd Loop.Types.Msg
playLoop user =
  Loop.State.play user.loop


stopLoop : Model -> Cmd Loop.Types.Msg
stopLoop user =
  Loop.State.stop user.loop
