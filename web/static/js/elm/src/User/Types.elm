module User.Types exposing (..)


import Dict exposing (Dict)
import Loop.Types


type alias ID = String


type alias Model =
  { id : ID
  , loopName : String
  , loop : Loop.Types.Model
  }


type alias Collection =
  Dict ID Model
