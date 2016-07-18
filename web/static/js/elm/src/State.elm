module State exposing (initialState, update, subscriptions)

import Debug
import Dict exposing (Dict)
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket

import Socket
import Types exposing (..)

import Loop.State
import Presence.State


initialState : { host : String } -> (Model, Cmd Msg)
initialState flags =
  let
    (loop, loopCmds) = Loop.State.initialState
    (socket, socketCmds) = Socket.joinChannel flags.host
  in
    ( { userId = ""
      , loopName = "80s_Back_Beat_01"
      , loop = loop
      , users = []
      , socket = socket
      , presences = Dict.empty
      }
    , Cmd.batch
        [ Cmd.map Loop loopCmds
        , Cmd.map SocketMsg socketCmds
        ]
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

    SetUserId id ->
      { model | userId = id } ! []

    SocketMsg msg ->
      let
        ( socket, socketCmds ) = Phoenix.Socket.update msg model.socket
      in
        ( { model | socket = socket }
        , Cmd.map SocketMsg socketCmds
        )

    PresenceStateMsg json ->
      let
        (users, presences) =
          Presence.State.updatePresenceState model.presences json
      in
        { model | users = users, presences = presences } ! []

    PresenceDiffMsg json ->
      let
        (users, presences) =
           Presence.State.updatePresenceDiff model.presences json
      in
        { model | users = users, presences = presences } ! []


subscriptions : Model -> Sub Msg
subscriptions model =
  Phoenix.Socket.listen model.socket SocketMsg
