module App exposing (main)


import Audio exposing (defaultPlaybackOptions)
import Html.App
import Task exposing (andThen)
import View exposing (..)


main : Program Never
main =
  Html.App.program
    { init = init
    , view = root
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


init : (String, Cmd Msg)
init =
  (""
  , initSound
  )


initSound : Cmd Msg
initSound =
  let
    url = "sounds/80s_Back_Beat_01.m4a"
  in
    Task.perform PlayFail PlaySucceed (playSound url)


playSound : String -> Task.Task String ()
playSound url =
  Audio.loadSound url
  `andThen`
  (Task.mapError (\_ -> "") << Audio.playSound Audio.defaultPlaybackOptions)



-- UPDATE


type Msg
  = PlaySucceed ()
  | PlayFail String


update : Msg -> a -> (a, Cmd Msg)
update msg model =
  (model, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : a -> Sub b
subscriptions model =
  Sub.none
