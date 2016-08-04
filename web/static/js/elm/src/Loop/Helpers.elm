module Loop.Helpers exposing (..)


import Loop.Types exposing (..)


isPlayingOrQueued : Model -> Bool
isPlayingOrQueued model =
  case model.state of
    Playing -> True
    Queued -> True
    NotPlaying -> False
