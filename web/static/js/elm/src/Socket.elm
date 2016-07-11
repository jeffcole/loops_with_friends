module Socket exposing (joinChannel)


import Json.Encode as JE
import Phoenix.Channel
import Phoenix.Socket

import Types exposing (Msg(..))


joinChannel :
  String -> (Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg))
joinChannel host =
  Phoenix.Socket.join channel (initialSocket host)


channel : Phoenix.Channel.Channel Msg
channel =
  Phoenix.Channel.init "jams:1"
  |> Phoenix.Channel.withPayload userParams


initialSocket : String -> Phoenix.Socket.Socket Msg
initialSocket host =
  Phoenix.Socket.init (socketUrl host)
  |> Phoenix.Socket.withDebug
  |> Phoenix.Socket.on "presence_state" "jams:1" PresenceStateMsg
  |> Phoenix.Socket.on "presence_diff" "jams:1" PresenceDiffMsg


socketUrl : String -> String
socketUrl host =
  socketProtocol host ++ host ++ "/socket/websocket"


socketProtocol : String -> String
socketProtocol host =
  if host == "localhost:4000"
    then "ws://"
    else "wss://"


userParams : JE.Value
userParams =
  JE.object [ ("user_param", JE.string "User Param") ]
