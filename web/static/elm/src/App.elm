module App exposing (main)

import Html
import State
import View
import Types exposing (Model, Msg)


main : Program { host : String, topic : String } Model Msg
main =
    Html.programWithFlags
        { init = State.initialState
        , update = State.update
        , view = View.root
        , subscriptions = State.subscriptions
        }
