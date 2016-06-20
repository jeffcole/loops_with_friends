module App exposing (main)


import Html.App
import View exposing (..)


main : Program Never
main =
  Html.App.program
    { init = init
    , view = root
    , update = update
    , subscriptions = subscriptions
    }


init : (String, Cmd a)
init =
  (""
  , Cmd.none
  )


update : a -> a
update model =
  model


subscriptions : a -> Sub b
subscriptions model =
  Sub.none
