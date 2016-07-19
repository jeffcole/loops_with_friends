module Types exposing (..)


import Json.Encode as JE
import Phoenix.Presence exposing (PresenceState)
import Phoenix.Socket

import Loop.Types
import Presence.Types
import User.Types


type alias Model =
  { userId : User.Types.ID
  , loopName : String
  , loop : Loop.Types.Model
  , users : List User.Types.Model
  , socket : Phoenix.Socket.Socket Msg
  , presences : PresenceState Presence.Types.UserPresence
  }


type Msg
  = SetUserId String
  | LoopMsg Loop.Types.Msg
  | SocketMsg (Phoenix.Socket.Msg Msg)
  | PresenceStateMsg JE.Value
  | PresenceDiffMsg JE.Value
