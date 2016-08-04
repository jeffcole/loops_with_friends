module User.State exposing
  ( emptyCollection
  , emptyUser
  , emptyLoopCmd
  , playLoop
  , queueLoop
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


playLoop : Model -> (Model, Cmd Msg)
playLoop model =
  ( model
  , Loop.State.play model.loop
  )


queueLoop : Model -> (Model, Cmd Msg)
queueLoop model =
  let
    (loop, cmds) = Loop.State.queue model.loop
  in
    ( { model | loop = loop }
    , cmds
    )


stopLoop : Model -> (Model, Cmd Msg)
stopLoop model =
  ( model
  , Loop.State.stop model.loop
  )


update : Msg -> Model -> (Model, Cmd Msg, Loop.Types.OutMsg)
update msg model =
  let
    (loop, loopCmds, outMsg) = Loop.State.update msg model.loop
  in
    ( { model | loop = loop }
    , loopCmds
    , outMsg
    )
