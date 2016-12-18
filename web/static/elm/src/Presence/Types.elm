module Presence.Types exposing (..)

import Loop.Types
import User.Types


type alias UserPresence =
    { userId : User.Types.ID
    , loopName : String
    , loopEvent : Loop.Types.Event
    }
