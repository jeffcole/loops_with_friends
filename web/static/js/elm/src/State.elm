module State exposing (initialState, update, subscriptions)


import Task exposing (Task, andThen)

import Audio
import Types exposing (..)


initialState : (String, Cmd Msg)
initialState =
  (""
  , initSound
  )


update : Msg -> a -> (a, Cmd Msg)
update msg model =
  (model, Cmd.none)


subscriptions : a -> Sub b
subscriptions model =
  Sub.none


initSound : Cmd Msg
initSound =
  let
    url = "sounds/80s_Back_Beat_01.m4a"
  in
    Task.perform PlayFail PlaySucceed (loadAndPlaySound url)


loadAndPlaySound : String -> Task String ()
loadAndPlaySound url =
  Audio.loadSound url `andThen` playSound


playSound : Audio.Sound -> Task String ()
playSound =
  Task.mapError (\_ -> "") << Audio.playSound Audio.defaultPlaybackOptions
