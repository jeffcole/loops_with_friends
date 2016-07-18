module User.Types exposing (..)


import Loop.Types


type alias Model =
  { id : String
  , loopName : String
  , loop : Loop.Types.Model
  }
