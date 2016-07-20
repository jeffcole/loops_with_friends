module Player.Types exposing (..)


type Msg
  = Play
  | Stop


type OutMsg
  = Played
  | Stopped
  | NoMsg
