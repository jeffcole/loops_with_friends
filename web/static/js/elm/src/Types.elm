module Types exposing (..)


import Json.Encode as JE
import Phoenix.Presence exposing (PresenceState)
import Phoenix.Socket

import Loop.Types
import Presence.Types
import User.Types


type alias Model =
  { userId : User.Types.ID
  , users : User.Types.Collection
  , socket : Phoenix.Socket.Socket Msg
  , presences : PresenceState Presence.Types.UserPresence
  }


type Msg
  = SetUserId String
  | Play
  | Stop
  | LoopMsg User.Types.ID Loop.Types.Msg
  | UserPlayed JE.Value
  | UserStopped JE.Value
  | SocketMsg (Phoenix.Socket.Msg Msg)
  | PresenceStateMsg JE.Value
  | PresenceDiffMsg JE.Value
