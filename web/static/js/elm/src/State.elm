module State exposing (initialState, update, subscriptions)


import Task exposing (Task)

import WebAudio
import Types exposing (..)


initialState : (Model, Cmd Msg)
initialState =
  ( Model Stopped NotLoaded
  , performLoadSound
  )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Play ->
      ( model
      , performPlaySound model.sound
      )

    Stop ->
      ( model
      , performStopSound model.sound
      )

    LoadSucceed audioSound ->
      ( { model | sound = Loaded audioSound }
      , Cmd.none
      )

    LoadFail error ->
      (model, Cmd.none)

    PlaySucceed audioSound ->
      ( Model Playing (Loaded audioSound)
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


performPlaySound : Sound -> Cmd Msg
performPlaySound sound =
  case sound of
    Loaded audioSound ->
      Task.perform PlayFail PlaySucceed (playSound audioSound)
    NotLoaded ->
      Cmd.none


playSound : WebAudio.Sound -> Task String WebAudio.Sound
playSound audioSound =
  WebAudio.playSound audioSound


performStopSound : Sound -> Cmd Msg
performStopSound sound =
  case sound of
    Loaded audioSound ->
      Task.perform StopFail StopSucceed (stopSound audioSound)
    NotLoaded ->
      Cmd.none


stopSound : WebAudio.Sound -> Task Never ()
stopSound audioSound =
  WebAudio.stopSound audioSound


subscriptions : a -> Sub b
subscriptions model =
  Sub.none
