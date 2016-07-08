module State exposing (initialState, update, subscriptions)


import Types exposing (..)

import Loop.State


initialState : { host : String } -> (Model, Cmd Msg)
initialState flags =
  let
    (loop, loopCmds) = Loop.State.initialState
  in
    ( { host = flags.host
      , loop = loop
      }
    , Cmd.map Loop loopCmds
    )


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    Loop msg ->
      let
        (loop, loopCmds) = Loop.State.update msg model.loop
      in
        ( { model | loop = loop }
        , Cmd.map Loop loopCmds
        )


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
