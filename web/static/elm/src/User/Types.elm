module User.Types exposing (..)


import Dict exposing (Dict)

import Loop.State
import Loop.Types


type alias ID = String


type alias Model =
  { id : ID
  , loop : Loop.Types.Model
  }


type alias Collection =
  Dict ID Model


type alias Msg = Loop.Types.Msg


type alias LoopCmd =
  { userId : ID
  , cmds : Cmd Loop.Types.Msg
  }


emptyCollection : Collection
emptyCollection =
  Dict.empty


emptyModel : Model
emptyModel =
  Loop.Types.initialModel ""
  |> Model "Empty User"


emptyLoopCmd : LoopCmd
emptyLoopCmd =
  LoopCmd "Empty User" Cmd.none
