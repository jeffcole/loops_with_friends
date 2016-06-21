module App exposing (main)


import Html.App

import State
import View


main : Program Never
main =
  Html.App.program
    { init = State.initialState
    , update = State.update
    , view = View.root
    , subscriptions = State.subscriptions
    }
