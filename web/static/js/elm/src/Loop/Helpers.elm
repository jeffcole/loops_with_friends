module Loop.Helpers exposing (..)


import Loop.Types exposing (..)


isPlaying : Model -> Bool
isPlaying model =
  case model.state of
    Playing -> True
    NotPlaying -> False
