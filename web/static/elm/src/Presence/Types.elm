module Presence.Types exposing (..)


import User.Types


type alias UserPresence =
  { userId : User.Types.ID
  , loopName : String
  }
