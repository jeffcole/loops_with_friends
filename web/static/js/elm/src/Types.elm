module Types exposing (..)

type Msg
  = Play
  | PlaySucceed ()
  | PlayFail String
