module Player.State exposing (update)


import Loop.State
import Loop.Types
import Player.Types exposing (..)


update
  :  Msg
  -> Loop.Types.Model
  -> (Loop.Types.Model, Cmd Loop.Types.Msg, OutMsg)
update message loop =
  case message of
    Play ->
      let
        (loop, loopCmds) = Loop.State.update Loop.Types.Play loop
      in
        (loop, loopCmds, Played)
    Stop ->
      let
        (loop, loopCmds) = Loop.State.update Loop.Types.Stop loop
      in
        (loop, loopCmds, Stopped)
