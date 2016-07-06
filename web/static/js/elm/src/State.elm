port module State exposing (initialState, update, subscriptions)


import Types exposing (..)

import Loop.State


initialState : (Model, Cmd Msg)
initialState =
  let
    (loop, loopCmds) = Loop.State.initialState
  in
    ( { host = ""
      , loop = loop
      }
    , Cmd.map Loop loopCmds
    )


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    Host host ->
      ( { model | host = host }
      , Cmd.none
      )

    Loop msg ->
      let
        (loop, loopCmds) = Loop.State.update msg model.loop
      in
        ( { model | loop = loop }
        , Cmd.map Loop loopCmds
        )


port host : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
  host Host
