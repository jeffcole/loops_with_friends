module Types exposing (..)


import Loop.Types
import Phoenix.Socket


type alias Model =
  { loop : Loop.Types.Model
  , socket : Phoenix.Socket.Socket Msg
  }


type Msg
  = Loop Loop.Types.Msg
  | SocketMsg (Phoenix.Socket.Msg Msg)
