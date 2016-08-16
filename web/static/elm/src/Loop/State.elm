module Loop.State exposing (initialState, update, queue, play, stop)


import Task exposing (Task)

import WebAudio

import Loop.Types exposing (..)


initialState : String -> (Model, Cmd Msg)
initialState name =
  ( initialModel name
  , performLoad name
  )


update : Msg -> Model -> (Model, OutMsg)
update msg model =
  case msg of
    LoadSucceed sound ->
      ( { model | sound = Loaded sound }
      , NoMsg
      )

    LoadFail error ->
      (model, NoMsg)

    PlaySucceed sound ->
      ( { model | state = Playing, sound = Loaded sound }
      , Played
      )

    PlayFail error ->
      (model, NoMsg)

    StopSucceed () ->
      ( { model | state = NotPlaying }
      , Stopped
      )

    StopFail never ->
      (model, NoMsg)


queue : Model -> (Model, Cmd Msg)
queue model =
  let
    state =
      case model.state of
        Playing ->
          Playing
        _ ->
          Queued
  in
    ( { model | state = state }
    , Cmd.none
    )


play : Model -> Cmd Msg
play model =
  case model.state of
    Playing ->
      Cmd.none
    _ ->
      performPlay model.sound


stop : Model -> (Model, Cmd Msg)
stop model =
  case model.state of
    Playing ->
      ( model
      , performStop model.sound
      )
    Queued ->
      ( {model | state = NotPlaying }
      , Cmd.none
      )
    _ ->
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
