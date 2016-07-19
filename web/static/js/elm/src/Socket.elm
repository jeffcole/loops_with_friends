module Socket exposing (joinChannel, pushLoopMsg)


import Json.Decode as JD exposing ((:=))
import Json.Encode as JE
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket

import Types exposing (Msg(..))

import Loop.Types


joinChannel :
  String -> (Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg))
joinChannel host =
  Phoenix.Socket.join channel (initialSocket host)


pushLoopMsg
  :  Loop.Types.OutMsg
  -> String
  -> Phoenix.Socket.Socket msg
  -> (Phoenix.Socket.Socket msg, Cmd (Phoenix.Socket.Msg msg))
pushLoopMsg message userId socket =
  case message of
    Loop.Types.Played ->
      Phoenix.Socket.push (push userId "played") socket

    Loop.Types.Stopped ->
      Phoenix.Socket.push (push userId "stopped") socket

    Loop.Types.NoMsg ->
      (socket, Cmd.none)


push : String -> String -> Phoenix.Push.Push msg
push userId event =
  Phoenix.Push.init ("loop:" ++ event) "jams:1"
    |> Phoenix.Push.withPayload (pushPayload userId)


pushPayload : String -> JE.Value
pushPayload userId =
  JE.object [ ("user_id", JE.string userId) ]


channel : Phoenix.Channel.Channel Msg
channel =
  Phoenix.Channel.init "jams:1"
  |> Phoenix.Channel.withPayload userParams
  |> Phoenix.Channel.onJoin setUserId


initialSocket : String -> Phoenix.Socket.Socket Msg
initialSocket host =
  Phoenix.Socket.init (socketUrl host)
  |> Phoenix.Socket.withDebug
  |> Phoenix.Socket.on "presence_state" "jams:1" PresenceStateMsg
  |> Phoenix.Socket.on "presence_diff" "jams:1" PresenceDiffMsg


userParams : JE.Value
userParams =
  JE.object [ ("user_param", JE.string "User Param") ]


setUserId : JE.Value -> Msg
setUserId json =
  SetUserId (decodeUserId json)


decodeUserId : JE.Value -> String
decodeUserId json =
  case JD.decodeValue ("user_id" := JD.string) json of
    Ok userId -> userId
    Err message -> ""


socketUrl : String -> String
socketUrl host =
  socketProtocol host ++ host ++ "/socket/websocket"


socketProtocol : String -> String
socketProtocol host =
  if host == "localhost:4000"
    then "ws://"
    else "wss://"
