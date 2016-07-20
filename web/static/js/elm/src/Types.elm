module Types exposing (..)


import Dict exposing (Dict)
import Json.Encode as JE
import Phoenix.Presence exposing (PresenceState)
import Phoenix.Socket

import Loop.Types
import Player.Types
import Presence.Types
import User.Types


type alias Model =
  { userId : User.Types.ID
  , loopName : String
  , loop : Loop.Types.Model
  , users : User.Types.Collection
  , socket : Phoenix.Socket.Socket Msg
  , presences : PresenceState Presence.Types.UserPresence
  }


type Msg
  = SetUserId String
  | PlayerMsg Player.Types.Msg
  | LoopMsg Loop.Types.Msg
  | UserPlayed JE.Value
  | UserStopped JE.Value
  | SocketMsg (Phoenix.Socket.Msg Msg)
  | PresenceStateMsg JE.Value
  | PresenceDiffMsg JE.Value
