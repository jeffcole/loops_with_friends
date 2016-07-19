module User.Types exposing (..)


import Loop.Types


type alias ID = String


type alias Model =
  { id : ID
  , loopName : String
  , loop : Loop.Types.Model
  }
