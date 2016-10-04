module State exposing (initialState, update, subscriptions)

import Debug
import Dict
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket
import Time

import Loop.Types
import Presence.State
import User.Helpers
import User.State
import User.Types

import Helpers
import Socket
import Types exposing (..)


initialState : { host : String, topic : String } -> (Model, Cmd Msg)
initialState flags =
  let
    (socket, socketCmds) = Socket.joinChannel flags.host flags.topic
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
    SetUserId userId ->
      { model | userId = userId } ! []

    RetryJoin newTopic ->
      let
        {path} = model.socket
        host = Socket.pathToHost path
        (socket, socketCmds) = Socket.joinChannel host newTopic
      in
        ( { model | socket = socket }
        , Cmd.map SocketMsg socketCmds
        )

    Play ->
      let
        playerUser = Helpers.playerUser model
        (user, cmds) = User.State.queueLoop playerUser
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
        (newUser, cmds) = User.State.stopLoop user
        users = User.Helpers.replace newUser model.users
      in
        ( { model | users = users }
        , Cmd.map (UserMsg userId) cmds
        )

    UserMsg userId userMsg ->
      let
        user = User.Helpers.getUser userId model.users
        (newUser, userCmds, outMsg) = User.State.update userMsg user
        newUsers = User.Helpers.replace newUser model.users
        (socket, socketCmds) = pushIfPlayerUser outMsg userId model
      in
        ( { model | users = newUsers, socket = socket }
        , Cmd.batch
            [ Cmd.map (UserMsg userId) userCmds
            , Cmd.map SocketMsg socketCmds
            ]
        )

    MeasureStart time ->
      let
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

    NoOp ->
      (model, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ measureSubscriptions model
    , Phoenix.Socket.listen model.socket SocketMsg
    ]


measureSubscriptions : Model -> Sub Msg
measureSubscriptions model =
  if User.Helpers.anyLoopsQueued model.users
    then Time.every (4.799625 * Time.second) MeasureStart
    else Sub.none


pushIfPlayerUser
  :  Loop.Types.OutMsg
  -> User.Types.ID
  -> Model
  -> (Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg))
pushIfPlayerUser outMsg userId model =
  if userId == model.userId
    then Socket.pushUserMsg outMsg userId model.socket
    else (model.socket, Cmd.none)
