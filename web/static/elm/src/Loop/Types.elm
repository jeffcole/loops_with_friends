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
  | StopFail Never


type OutMsg
  = Played
  | Stopped
  | NoMsg


initialModel : String -> Model
initialModel name =
  { name = name
  , sound = NotLoaded
  , state = NotPlaying
  }
