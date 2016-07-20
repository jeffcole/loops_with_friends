module Loop.Types exposing (..)


import WebAudio


type alias Model =
  { sound : Sound
  , state : State
  }


type Sound
  = NotLoaded
  | Loaded WebAudio.Sound


type State
  = Playing
  | NotPlaying


type Msg
  = LoadSucceed WebAudio.Sound
  | LoadFail String
  | Play
  | Stop
  | PlaySucceed WebAudio.Sound
  | PlayFail String
  | StopSucceed ()
  | StopFail Never
