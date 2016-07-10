module State exposing (initialState, update, subscriptions)


import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket

import Socket
import Types exposing (..)

import Loop.State


initialState : { host : String } -> (Model, Cmd Msg)
initialState flags =
  let
    (loop, loopCmds) = Loop.State.initialState
  in
    ( { loop = loop
      , socket = Socket.initialSocket flags.host
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

    SocketMsg msg ->
      let
        ( socket, socketCmds ) = Phoenix.Socket.update msg model.socket
      in
        ( { model | socket = socket }
        , Cmd.map SocketMsg socketCmds
        )


subscriptions : Model -> Sub Msg
subscriptions model =
  Phoenix.Socket.listen model.socket SocketMsg
