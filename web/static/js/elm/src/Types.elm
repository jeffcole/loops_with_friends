module Types exposing (..)


import Json.Encode as JE
import Phoenix.Presence exposing (PresenceState)
import Phoenix.Socket

import Loop.Types


type alias Model =
  { loop : Loop.Types.Model
  , userId : String
  , users : List User
  , socket : Phoenix.Socket.Socket Msg
  , presences : PresenceState UserPresence
  }


type alias User =
  { id : String }


type alias UserPresence =
  { loop_name : String }


type Msg
  = Loop Loop.Types.Msg
  | SetUserId String
  | SocketMsg (Phoenix.Socket.Msg Msg)
  | PresenceStateMsg JE.Value
  | PresenceDiffMsg JE.Value
