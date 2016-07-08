module Types exposing (..)


import Loop.Types


type alias Model =
  { host : String
  , loop : Loop.Types.Model
  }


type Msg
  = Loop Loop.Types.Msg
