module State exposing (initialState, update, subscriptions)

import Debug
import Dict exposing (Dict)
import Json.Decode as JD exposing ((:=))
import Json.Decode.Pipeline as JDP
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Presence exposing
  ( PresenceState
  , presenceDiffDecoder
  , presenceStateDecoder
  , syncDiff
  , syncState
  )
import Phoenix.Socket

import Socket
import Types exposing (..)

import Loop.State


initialState : { host : String } -> (Model, Cmd Msg)
initialState flags =
  let
    (loop, loopCmds) = Loop.State.initialState
    (socket, socketCmds) = Socket.joinChannel flags.host
  in
    ( { loop = loop
      , userId = ""
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

    PresenceStateMsg raw ->
      case JD.decodeValue (presenceStateDecoder userPresenceDecoder) raw of
        Ok presenceState ->
          let
            newPresenceState = model.presences |> syncState presenceState
            users = Dict.keys newPresenceState |> List.map User
          in
            { model | users = users, presences = newPresenceState } ! []
        Err error ->
          let
            _ = Debug.log "Error" error
          in
            model ! []

    PresenceDiffMsg raw ->
      case JD.decodeValue (presenceDiffDecoder userPresenceDecoder) raw of
        Ok presenceDiff ->
          let
            newPresenceState = model.presences |> syncDiff presenceDiff
            users = Dict.keys newPresenceState |> List.map User
          in
            { model | users = users, presences = newPresenceState } ! []
        Err error ->
            let
              _ = Debug.log "Error" error
            in
              model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
  Phoenix.Socket.listen model.socket SocketMsg


userPresenceDecoder : JD.Decoder UserPresence
userPresenceDecoder =
    JDP.decode UserPresence
      |> JDP.required "loop_name" JD.string
