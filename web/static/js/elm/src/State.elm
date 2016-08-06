module State exposing (initialState, update, subscriptions)

import Debug
import Dict
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket
import Time

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
      , users = User.Types.emptyCollection
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
        playerUser = Helpers.playerUser model
        (user, cmds) =
          if User.Helpers.anyLoopsPlaying model.users
            then User.State.queueLoop playerUser
            else User.State.playLoop playerUser
        users = User.Helpers.replace user model.users
      in
        ( { model | users = users }
        , Cmd.map (UserMsg model.userId) cmds
        )

    Stop ->
      let
        (_, cmds) = Helpers.playerUser model |> User.State.stopLoop
      in
        (model, Cmd.map (UserMsg model.userId) cmds)

    UserPlayed json ->
      let
        userId = Socket.decodeUserId json
        user = User.Helpers.getUser userId model.users
        (newUser, cmds) = User.State.queueLoop user
        users = User.Helpers.replace newUser model.users
      in
        ( { model | users = users }
        , Cmd.map (UserMsg userId) cmds
        )

    UserStopped json ->
      let
        userId = Socket.decodeUserId json
        user = User.Helpers.getUser userId model.users
        (_, cmds) = User.State.stopLoop user
      in
        ( model
        , Cmd.map (UserMsg userId) cmds
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

    MeasureStart time ->
      let
        _ = Debug.log "MeasureStart" time
        (users, cmds) = User.State.playQueuedLoops model.users
      in
        ( { model | users = users }
        , Cmd.batch (List.map Helpers.tagUserCmds cmds)
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
  Sub.batch
    [ measureSubscriptions model
    , Phoenix.Socket.listen model.socket SocketMsg
    ]

measureSubscriptions : Model -> Sub Msg
measureSubscriptions model =
  if User.Helpers.anyLoopsPlaying model.users
    then Time.every (4.799625 * Time.second) MeasureStart
    else Sub.none
