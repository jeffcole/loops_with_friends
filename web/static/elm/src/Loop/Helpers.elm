module Loop.Helpers exposing (..)


import Loop.Types exposing (..)


isPlayingOrQueued : Model -> Bool
isPlayingOrQueued model =
  case model.state of
    Playing -> True
    Queued -> True
    NotPlaying -> False


isQueued : Model -> Bool
isQueued model =
  case model.state of
    Queued -> True
    _ -> False
