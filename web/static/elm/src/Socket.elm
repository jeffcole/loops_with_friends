module Socket exposing (joinChannel, pushUserMsg, decodeUserId, pathToHost)

import Erl
import Debug
import Dict
import Json.Decode as JD exposing (field)
import Json.Encode as JE
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket
import String
import Loop.Types
import User.Types
import Types exposing (Msg(..))


joinChannel : String -> String -> ( Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg) )
joinChannel host topic =
    Phoenix.Socket.join (channel topic) (initialSocket host topic)


pushUserMsg :
    Loop.Types.OutMsg
    -> User.Types.ID
    -> Phoenix.Socket.Socket msg
    -> ( Phoenix.Socket.Socket msg, Cmd (Phoenix.Socket.Msg msg) )
pushUserMsg msg userId socket =
    let
        topic =
            socketTopic socket

        pushEvent =
            push topic userId
    in
        case msg of
            Loop.Types.Played ->
                Phoenix.Socket.push (pushEvent "played") socket

            Loop.Types.Stopped ->
                Phoenix.Socket.push (pushEvent "stopped") socket

            Loop.Types.NoMsg ->
                ( socket, Cmd.none )


decodeUserId : JE.Value -> User.Types.ID
decodeUserId json =
    case JD.decodeValue (field "user_id" JD.string) json of
        Ok userId ->
            userId

        Err message ->
            ""


pathToHost : String -> String
pathToHost path =
    let
        url =
            Erl.parse path

        host =
            url.host |> String.join "."

        port_ =
            url.port_
    in
        case port_ of
            0 ->
                host

            _ ->
                String.join ":" [ host, toString port_ ]


channel : String -> Phoenix.Channel.Channel Msg
channel topic =
    Phoenix.Channel.init topic
        |> Phoenix.Channel.withPayload userParams
        |> Phoenix.Channel.onJoin setUserId
        |> Phoenix.Channel.onError retryJoin


initialSocket : String -> String -> Phoenix.Socket.Socket Msg
initialSocket host topic =
    Phoenix.Socket.init (socketUrl host)
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on "presence_state" topic PresenceStateMsg
        |> Phoenix.Socket.on "presence_diff" topic PresenceDiffMsg
        |> Phoenix.Socket.on "loop:played" topic UserPlayed
        |> Phoenix.Socket.on "loop:stopped" topic UserStopped


userParams : JE.Value
userParams =
    JE.object [ ( "user_param", JE.string "User Param" ) ]


setUserId : JE.Value -> Msg
setUserId json =
    SetUserId (decodeUserId json)


retryJoin : JE.Value -> Msg
retryJoin json =
    let
        newTopic =
            decodeNewTopic json
    in
        case newTopic of
            "" ->
                NoOp

            _ ->
                RetryJoin newTopic


decodeNewTopic : JE.Value -> String
decodeNewTopic json =
    case JD.decodeValue (field "new_topic" JD.string) json of
        Ok newTopic ->
            newTopic

        Err message ->
            ""


socketUrl : String -> String
socketUrl host =
    socketProtocol host ++ host ++ "/socket/websocket"


socketProtocol : String -> String
socketProtocol host =
    "ws://"


socketTopic : Phoenix.Socket.Socket msg -> String
socketTopic socket =
    socket.channels
        |> Dict.keys
        |> List.head
        |> Maybe.withDefault "unknown_topic"


push : String -> User.Types.ID -> String -> Phoenix.Push.Push msg
push topic userId event =
    Phoenix.Push.init ("loop:" ++ event) topic
        |> Phoenix.Push.withPayload (pushPayload userId)


pushPayload : User.Types.ID -> JE.Value
pushPayload userId =
    JE.object [ ( "user_id", JE.string userId ) ]
