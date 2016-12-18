module User.Helpers exposing (..)

import Dict
import Loop.Helpers
import Loop.Types
import User.Types exposing (..)


getUser : ID -> Collection -> Model
getUser id collection =
    Dict.get id collection
        |> Maybe.withDefault emptyModel


loopState : Model -> Loop.Types.State
loopState model =
    model.loop.state


replace : Model -> Collection -> Collection
replace user users =
    users
        |> Dict.remove user.id
        |> Dict.insert user.id user


anyLoopsQueued : Collection -> Bool
anyLoopsQueued collection =
    Dict.values collection
        |> List.map .loop
        |> List.any Loop.Helpers.isQueuedOrPlaying


hasQueuedLoop : Model -> Bool
hasQueuedLoop model =
    Loop.Helpers.isQueuedOrPlaying model.loop
