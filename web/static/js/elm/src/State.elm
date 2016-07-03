port module State exposing (initialState, update, subscriptions)


import Task exposing (Task)

import WebAudio
import Types exposing (..)


initialState : (Model, Cmd Msg)
initialState =
  ( { host = "", state = Stopped, loop = NotLoaded }
  , performLoadSound
  )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Host host ->
      ( { model | host = host }
      , Cmd.none
      )

    Play ->
      ( model
      , performPlayLoop model.loop
      )

    Stop ->
      ( model
      , performStopLoop model.loop
      )

    LoadSucceed sound ->
      ( { model | loop = Loaded sound }
      , Cmd.none
      )

    LoadFail error ->
      (model, Cmd.none)

    PlaySucceed sound ->
      ( { model | state = Playing, loop = Loaded sound }
      , Cmd.none
      )

    PlayFail error ->
      (model, Cmd.none)

    StopSucceed () ->
      ( { model | state = Stopped }
      , Cmd.none
      )

    StopFail never ->
      (model, Cmd.none)


performLoadSound : Cmd Msg
performLoadSound =
  let
    url = "sounds/80s_Back_Beat_01.m4a"
  in
    Task.perform LoadFail LoadSucceed (loadSound url)


loadSound : String -> Task String WebAudio.Sound
loadSound url =
  WebAudio.loadSound url


performPlayLoop : Loop -> Cmd Msg
performPlayLoop loop =
  case loop of
    Loaded sound ->
      Task.perform PlayFail PlaySucceed (playSound sound)
    NotLoaded ->
      Cmd.none


playSound : WebAudio.Sound -> Task String WebAudio.Sound
playSound sound =
  WebAudio.playSound sound


performStopLoop : Loop -> Cmd Msg
performStopLoop loop =
  case loop of
    Loaded sound ->
      Task.perform StopFail StopSucceed (stopSound sound)
    NotLoaded ->
      Cmd.none


stopSound : WebAudio.Sound -> Task Never ()
stopSound sound =
  WebAudio.stopSound sound


port host : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
  host Host
