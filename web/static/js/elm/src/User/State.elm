module User.State exposing (empty, update)


import Dict exposing (Dict)

import Loop.State
import Loop.Types
import User.Types exposing (..)


empty : Model
empty =
  let
    (loop, loopCmds) = Loop.State.initialState ""
  in
    Model "" "" loop


update : Msg -> Model -> (Model, Cmd Loop.Types.Msg)
update message model =
  case message of
    Played ->
      let
        (loop, loopCmds) = Loop.State.update Loop.Types.Play model.loop
      in
        ( { model | loop = loop }
        , loopCmds
        )

    Stopped ->
      let
        (loop, loopCmds) = Loop.State.update Loop.Types.Stop model.loop
      in
        ( { model | loop = loop }
        , loopCmds
        )
