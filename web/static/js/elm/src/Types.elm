module Types exposing (..)


import WebAudio


type alias Model =
  { state : State
  , sound : Sound
  }


type State
  = Playing
  | Stopped


type Sound
  = Loaded WebAudio.Sound
  | NotLoaded


type Msg
  = Play
  | Stop
  | LoadSucceed WebAudio.Sound
  | LoadFail String
  | PlaySucceed WebAudio.Sound
  | PlayFail String
  | StopSucceed ()
  | StopFail Never
