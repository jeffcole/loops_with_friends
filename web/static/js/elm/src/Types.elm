module Types exposing (..)


import Audio


type alias Model =
  { state : State
  , sound : Sound
  }


type State
  = Playing
  | Stopped


type Sound
  = Loaded Audio.Sound
  | NotLoaded


type Msg
  = Play
  | Stop
  | LoadSucceed Audio.Sound
  | LoadFail String
  | PlaySucceed ()
  | PlayFail String
  | StopSucceed ()
  | StopFail Never
