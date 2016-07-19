module Loop.State exposing (initialState, update)


import Task exposing (Task)

import WebAudio

import Loop.Types exposing (..)


initialState : String -> (Model, Cmd Msg)
initialState name =
  ( { sound = NotLoaded
    , state = NotPlaying
    }
  ,
    performLoad name
  )


update : Msg -> Model -> (Model, Cmd Msg, OutMsg)
update msg model =
  case msg of
    LoadSucceed sound ->
      ( { model | sound = Loaded sound }
      , Cmd.none
      , NoMsg
      )

    LoadFail error ->
      (model, Cmd.none, NoMsg)

    Play ->
      ( model
      , performPlay model.sound
      , NoMsg
      )

    PlaySucceed sound ->
      ( { model | state = Playing, sound = Loaded sound }
      , Cmd.none
      , Played
      )

    PlayFail error ->
      (model, Cmd.none, NoMsg)

    Stop ->
      ( model
      , performStop model.sound
      , NoMsg
      )

    StopSucceed () ->
      ( { model | state = NotPlaying }
      , Cmd.none
      , Stopped
      )

    StopFail never ->
      (model, Cmd.none, NoMsg)


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
