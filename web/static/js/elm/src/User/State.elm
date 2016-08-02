module User.State exposing
  ( emptyCollection
  , emptyUser
  , emptyLoopCmd
  , playLoop
  , stopLoop
  , update
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


playLoop : Model -> Cmd Msg
playLoop user =
  Loop.State.play user.loop


stopLoop : Model -> Cmd Msg
stopLoop user =
  Loop.State.stop user.loop


update : Msg -> Model -> (Model, Cmd Msg, Loop.Types.OutMsg)
update msg model =
  let
    (loop, loopCmds, outMsg) = Loop.State.update msg model.loop
  in
    ( { model | loop = loop }
    , loopCmds
    , outMsg
    )
