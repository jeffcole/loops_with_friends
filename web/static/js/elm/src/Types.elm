module Types exposing (..)


import WebAudio


type alias Model =
  { state : State
  , loop : Loop
  }


type State
  = Playing
  | Stopped


type Loop
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
