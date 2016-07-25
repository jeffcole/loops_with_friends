module State exposing (initialState, update, subscriptions)

import Debug
import Dict exposing (Dict)
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket

import Loop.State
import Presence.State
import User.State
import User.Types

import Helpers
import Socket
import Types exposing (..)


initialState : { host : String } -> (Model, Cmd Msg)
initialState flags =
  let
    (socket, socketCmds) = Socket.joinChannel flags.host
  in
    ( { userId = ""
      , users = User.State.emptyCollection
      , socket = socket
      , presences = Dict.empty
      }
    , Cmd.map SocketMsg socketCmds
    )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetUserId id ->
      { model | userId = id } ! []

    Play ->
      let
        cmds = Helpers.playerUser model |> User.State.playLoop
      in
        (model, Cmd.map (LoopMsg model.userId) cmds)

    Stop ->
      let
        cmds = Helpers.playerUser model |> User.State.stopLoop
      in
        (model, Cmd.map (LoopMsg model.userId) cmds)

    UserPlayed json ->
      let
        userId = Socket.decodeUserId json
        user = Helpers.getUser userId model.users
        loopCmds = User.State.playLoop user
      in
        ( model
        , Cmd.map (LoopMsg userId) loopCmds
        )

    UserStopped json ->
      let
        userId = Socket.decodeUserId json
        user = Helpers.getUser userId model.users
        loopCmds = User.State.stopLoop user
      in
        ( model
        , Cmd.map (LoopMsg userId) loopCmds
        )

    LoopMsg userId loopMsg ->
      let
        user = Helpers.getUser userId model.users
        -- TODO Forward the message to the user and return (user, cmds, outMsg)
        (loop, loopCmds, outMsg) = Loop.State.update loopMsg user.loop
        newUser = { user | loop = loop }
        newUsers = Helpers.updateUser newUser model.users
        (socket, socketCmds) = Socket.pushLoopMsg outMsg userId model.socket
      in
        ( { model | users = newUsers, socket = socket }
        , Cmd.batch
            [ Cmd.map (LoopMsg userId) loopCmds
            , Cmd.map SocketMsg socketCmds
            ]
        )

    SocketMsg socketMsg ->
      let
        (socket, socketCmds) = Phoenix.Socket.update socketMsg model.socket
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
        , Cmd.batch (List.map Helpers.tagLoopCmds cmds)
        )

    PresenceDiffMsg json ->
      let
        (users, presences, cmds) =
          Presence.State.updatePresenceDiff model.users model.presences json
      in
        ( { model | users = users, presences = presences }
        , Cmd.batch (List.map Helpers.tagLoopCmds cmds)
        )


subscriptions : Model -> Sub Msg
subscriptions model =
  Phoenix.Socket.listen model.socket SocketMsg
