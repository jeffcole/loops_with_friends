module Loop.Types exposing (..)

import Dict exposing (Dict)
import WebAudio


type Name
    = String


type Sound
    = NotLoaded
    | Loaded WebAudio.Sound


type State
    = NotPlaying
    | Queued
    | Playing


type alias Model =
    { name : Name
    , sound : Sound
    , state : State
    }


type alias Collection =
    Dict Name Model


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


initialModel : Name -> Model
initialModel name =
    { name = name
    , sound = NotLoaded
    , state = NotPlaying
    }


initialModelFromEvent : Name -> Event -> Model
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
