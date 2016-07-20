module State exposing (initialState, update, subscriptions)

import Debug
import Dict exposing (Dict)
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket

import Socket
import Types exposing (..)

import Loop.State
import Player.State
import Presence.State
import User.State
import User.Types


initialState : { host : String } -> (Model, Cmd Msg)
initialState flags =
  let
    loopName = "80s_Back_Beat_01"
    (loop, loopCmds) = Loop.State.initialState loopName
    (socket, socketCmds) = Socket.joinChannel flags.host
  in
    ( { userId = ""
      , loopName = loopName
      , loop = loop
      , users = Dict.empty
      , socket = socket
      , presences = Dict.empty
      }
    , Cmd.batch
        [ Cmd.map LoopMsg loopCmds
        , Cmd.map SocketMsg socketCmds
        ]
    )


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    SetUserId id ->
      { model | userId = id } ! []

    PlayerMsg msg ->
      let
        (loop, loopCmds, outMsg) = Player.State.update msg model.loop
        (socket, socketCmds) =
          Socket.pushPlayerMsg outMsg model.userId model.socket
      in
        ( { model | loop = loop, socket = socket }
        , Cmd.batch
            [ Cmd.map LoopMsg loopCmds
            , Cmd.map SocketMsg socketCmds
            ]
        )

    UserPlayed json ->
      let
        userId = Socket.decodeUserId json
        user =
          Dict.get userId model.users
          |> Maybe.withDefault User.State.empty
        (newUser, cmds) = User.State.update User.Types.Played user
        users =
          model.users
          |> Dict.remove userId
          |> Dict.insert userId newUser
      in
        ( { model | users = users }
        , Cmd.map LoopMsg cmds
        )

    UserStopped json ->
      ( model
      , Cmd.none
      )

    LoopMsg msg ->
      let
        (loop, loopCmds) = Loop.State.update msg model.loop
      in
        ( { model | loop = loop }
        , Cmd.map LoopMsg loopCmds
        )

    SocketMsg msg ->
      let
        (socket, socketCmds) = Phoenix.Socket.update msg model.socket
      in
        ( { model | socket = socket }
        , Cmd.map SocketMsg socketCmds
        )

    PresenceStateMsg json ->
      let
        (users, presences, cmds) =
          Presence.State.updatePresenceState model.presences json
      in
        ( { model | users = users, presences = presences }
        , Cmd.map LoopMsg cmds
        )

    PresenceDiffMsg json ->
      let
        (users, presences) =
           Presence.State.updatePresenceDiff model.presences json
      in
        { model | users = users, presences = presences } ! []


subscriptions : Model -> Sub Msg
subscriptions model =
  Phoenix.Socket.listen model.socket SocketMsg
