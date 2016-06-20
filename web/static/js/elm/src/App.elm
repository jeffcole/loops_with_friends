module App exposing (main)


import Html.App
import View exposing (..)


main : Program Never
main =
  Html.App.beginnerProgram { model = "", view = root, update = update }


update : a -> a
update model =
  model
