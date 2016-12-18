module Loop.Types exposing (..)

import WebAudio


type alias Model =
    { name : String
    , sound : Sound
    , state : State
    }


type Sound
    = NotLoaded
    | Loaded WebAudio.Sound


type State
    = NotPlaying
    | Queued
    | Playing


type Msg
    = LoadSucceed WebAudio.Sound
    | LoadFail String
    | PlaySucceed WebAudio.Sound
    | PlayFail String
    | StopSucceed ()


type OutMsg
    = Played
    | Stopped
    | NoMsg


type Event
    = Play
    | NoEvent


initialModel : String -> Model
initialModel name =
    { name = name
    , sound = NotLoaded
    , state = NotPlaying
    }


initialModelFromEvent : String -> Event -> Model
initialModelFromEvent name event =
    let
        model =
            initialModel name
    in
        { model | state = stateFromEvent event }


stateFromEvent : Event -> State
stateFromEvent event =
    case event of
        Play ->
            Queued

        _ ->
            NotPlaying
