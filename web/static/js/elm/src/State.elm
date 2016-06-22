module State exposing (initialState, update, subscriptions)


import Task exposing (Task, andThen)

import Audio exposing (defaultPlaybackOptions)
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
      ( { model | state = Playing }
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

    PlaySucceed () ->
      stoppedModel model

    PlayFail error ->
      stoppedModel model

    StopSucceed () ->
      stoppedModel model

    StopFail never ->
      (model, Cmd.none)


performLoadSound : Cmd Msg
performLoadSound =
  let
    url = "sounds/80s_Back_Beat_01.m4a"
  in
    Task.perform LoadFail LoadSucceed (loadSound url)


loadSound : String -> Task String Audio.Sound
loadSound url =
  Audio.loadSound url


performPlaySound : Sound -> Cmd Msg
performPlaySound sound =
  case sound of
    Loaded audioSound ->
      Task.perform PlayFail PlaySucceed (playSound audioSound)
    NotLoaded ->
      Cmd.none


playSound : Audio.Sound -> Task String ()
playSound audioSound =
  Audio.playSound loopPlaybackOptions audioSound


loopPlaybackOptions : Audio.PlaybackOptions
loopPlaybackOptions =
  { defaultPlaybackOptions | loop = True }


performStopSound : Sound -> Cmd Msg
performStopSound sound =
  case sound of
    Loaded audioSound ->
      Task.perform StopFail StopSucceed (stopSound audioSound)
    NotLoaded ->
      Cmd.none


stopSound : Audio.Sound -> Task Never ()
stopSound audioSound =
  Audio.stopSound audioSound


stoppedModel : Model -> (Model, Cmd Msg)
stoppedModel model =
    ( { model | state = Stopped }
    , Cmd.none
    )


subscriptions : a -> Sub b
subscriptions model =
  Sub.none
