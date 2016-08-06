module User.State exposing
  ( playLoop
  , playQueuedLoops
  , queueLoop
  , stopLoop
  , update
  )


import Dict

import Lib.Helpers
import Loop.State
import Loop.Types

import User.Helpers
import User.Types exposing (..)


playLoop : Model -> (Model, Cmd Msg)
playLoop model =
  ( model
  , Loop.State.play model.loop
  )

playQueuedLoops : Collection -> (Collection, List LoopCmd)
playQueuedLoops collection =
  let
    (users, cmds) =
      collection
      |> Dict.values
      |> List.filter User.Helpers.hasQueuedLoop
      |> List.map usersAndPlayCmds
      |> List.unzip
    playingUsers = Lib.Helpers.identityDict .id users
  in
    ( Dict.union playingUsers collection
    , cmds
    )


usersAndPlayCmds : Model -> (Model, LoopCmd)
usersAndPlayCmds model =
  let
    (newModel, cmds) = playLoop model
  in
    ( model
    , LoopCmd newModel.id cmds
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
