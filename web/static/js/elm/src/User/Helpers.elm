module User.Helpers exposing (..)


import Dict

import Loop.Helpers
import Loop.Types

import User.State
import User.Types exposing (..)


getUser : ID -> Collection -> Model
getUser id collection =
  Dict.get id collection
  |> Maybe.withDefault User.State.emptyUser


loopName : Model -> String
loopName model =
  model.loop.name


loopState : Model -> Loop.Types.State
loopState model =
  model.loop.state


replace : Model -> Collection -> Collection
replace user users =
  users
  |> Dict.remove user.id
  |> Dict.insert user.id user


anyLoopsPlaying : Collection -> Bool
anyLoopsPlaying collection =
  Dict.values collection
  |> List.map .loop
  |> List.any Loop.Helpers.isPlaying