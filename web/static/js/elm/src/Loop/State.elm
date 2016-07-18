module Loop.State exposing (initialState, update)


import Task exposing (Task)

import WebAudio

import Loop.Types exposing (..)


initialState : String -> (Model, Cmd Msg)
initialState name =
  ( { sound = NotLoaded
    , state = Stopped
    }
  ,
    performLoad name
  )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadSucceed sound ->
      ( { model | sound = Loaded sound }
      , Cmd.none
      )

    LoadFail error ->
      (model, Cmd.none)

    Play ->
      ( model
      , performPlay model.sound
      )

    PlaySucceed sound ->
      ( { model | state = Playing, sound = Loaded sound }
      , Cmd.none
      )

    PlayFail error ->
      (model, Cmd.none)

    Stop ->
      ( model
      , performStop model.sound
      )

    StopSucceed () ->
      ( { model | state = Stopped }
      , Cmd.none
      )

    StopFail never ->
      (model, Cmd.none)


performLoad : String -> Cmd Msg
performLoad name =
  let
    url = "sounds/" ++ name ++ ".m4a"
  in
    Task.perform LoadFail LoadSucceed (loadSound url)


loadSound : String -> Task String WebAudio.Sound
loadSound url =
  WebAudio.loadSound url


performPlay : Sound -> Cmd Msg
performPlay sound =
  case sound of
    Loaded webAudioSound ->
      Task.perform PlayFail PlaySucceed (playSound webAudioSound)
    NotLoaded ->
      Cmd.none


playSound : WebAudio.Sound -> Task String WebAudio.Sound
playSound webAudioSound =
  WebAudio.playSound webAudioSound


performStop : Sound -> Cmd Msg
performStop sound =
  case sound of
    Loaded webAudioSound ->
      Task.perform StopFail StopSucceed (stopSound webAudioSound)
    NotLoaded ->
      Cmd.none


stopSound : WebAudio.Sound -> Task Never ()
stopSound webAudioSound =
  WebAudio.stopSound webAudioSound
