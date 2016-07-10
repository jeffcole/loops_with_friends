module Socket exposing (initialSocket)


import Phoenix.Socket

import Types exposing (Msg)


initialSocket : String -> Phoenix.Socket.Socket Msg
initialSocket host =
    Phoenix.Socket.init (socketUrl host)
    |> Phoenix.Socket.withDebug


socketUrl : String -> String
socketUrl host =
  socketProtocol host ++ host ++ "/socket/websocket"


socketProtocol : String -> String
socketProtocol host =
  if host == "localhost:4000"
    then "ws://"
    else "wss://"
