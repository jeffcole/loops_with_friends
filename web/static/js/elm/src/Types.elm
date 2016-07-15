module Types exposing (..)


import Json.Encode as JE
import Phoenix.Presence exposing (PresenceState)
import Phoenix.Socket

import Loop.Types


type alias Model =
  { userId : String
  , loopName : String
  , loop : Loop.Types.Model
  , users : List User
  , socket : Phoenix.Socket.Socket Msg
  , presences : PresenceState UserPresence
  }


type alias User =
  { id : String
  , loopName : String
  }


type alias UserPresence =
  { userId : String
  , loopName : String
  }


type Msg
  = Loop Loop.Types.Msg
  | SetUserId String
  | SocketMsg (Phoenix.Socket.Msg Msg)
  | PresenceStateMsg JE.Value
  | PresenceDiffMsg JE.Value
