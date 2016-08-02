module State exposing (initialState, update, subscriptions)

import Debug
import Dict
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket

import Presence.State
import User.Helpers
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
        (model, Cmd.map (UserMsg model.userId) cmds)

    Stop ->
      let
        cmds = Helpers.playerUser model |> User.State.stopLoop
      in
        (model, Cmd.map (UserMsg model.userId) cmds)

    UserPlayed json ->
      let
        userId = Socket.decodeUserId json
        user = User.Helpers.getUser userId model.users
        loopCmds = User.State.playLoop user
      in
        ( model
        , Cmd.map (UserMsg userId) loopCmds
        )

    UserStopped json ->
      let
        userId = Socket.decodeUserId json
        user = User.Helpers.getUser userId model.users
        loopCmds = User.State.stopLoop user
      in
        ( model
        , Cmd.map (UserMsg userId) loopCmds
        )

    UserMsg userId userMsg ->
      let
        user = User.Helpers.getUser userId model.users
        (newUser, userCmds, outMsg) = User.State.update userMsg user
        newUsers = User.Helpers.replace newUser model.users
        (socket, socketCmds) = Socket.pushUserMsg outMsg userId model.socket
      in
        ( { model | users = newUsers, socket = socket }
        , Cmd.batch
            [ Cmd.map (UserMsg userId) userCmds
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
        , Cmd.batch (List.map Helpers.tagUserCmds cmds)
        )

    PresenceDiffMsg json ->
      let
        (users, presences, cmds) =
          Presence.State.updatePresenceDiff model.users model.presences json
      in
        ( { model | users = users, presences = presences }
        , Cmd.batch (List.map Helpers.tagUserCmds cmds)
        )


subscriptions : Model -> Sub Msg
subscriptions model =
  Phoenix.Socket.listen model.socket SocketMsg
