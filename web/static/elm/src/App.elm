module App exposing (main)


import Html.App

import State
import View


main : Program { host : String }
main =
  Html.App.programWithFlags
    { init = State.initialState
    , update = State.update
    , view = View.root
    , subscriptions = State.subscriptions
    }
