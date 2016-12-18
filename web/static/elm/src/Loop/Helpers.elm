module Loop.Helpers exposing (..)

import Loop.Types exposing (..)


isQueuedOrPlaying : Model -> Bool
isQueuedOrPlaying model =
    case model.state of
        Queued ->
            True

        Playing ->
            True

        _ ->
            False
