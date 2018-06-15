module View exposing (root)

import Dialog
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Helpers
import Types exposing (..)
import Player.View
import User.Types
import User.View


root : Model -> Html Msg
root model =
    div [ class "container" ]
        [ bootstrap
        , div [ class "content" ]
            [ header []
                [ h1 [] [ text "Loops With Friends" ] ]
            , main_ []
                [ Player.View.root (Helpers.playerUser model)
                , usersView (Helpers.otherUsers model)
                ]
            ]
        , dialog model
        ]


usersView : User.Types.Collection -> Html Msg
usersView users =
    if Dict.isEmpty users then
        h2 []
            [ text "There's no one else here right now. Tell your friends to join!" ]
    else
        section []
            [ h2 [] [ text "Other Players' Loops" ]
            , ul [ class "grid-items" ] <|
                [ li [ class "grid-item placeholder" ] [] ]
                    ++ (Dict.values users |> List.map User.View.root)
            ]


dialog : Model -> Html Msg
dialog model =
    Dialog.view
        (if model.shouldShowDialog then
            Just
                { closeMessage = Just AcknowledgeDialog
                , containerClass = Just "text-center "
                , header = Just (text "Welcome to Loops With Friends!")
                , body =
                    Just
                        (button
                            [ onClick AcknowledgeDialog
                            , style [ ( "color", "white" ) ]
                            ]
                            [ text "Let's Jam" ]
                        )
                , footer = Nothing
                }
         else
            Nothing
        )


bootstrap : Html msg
bootstrap =
    node "link"
        [ href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
        , rel "stylesheet"
        ]
        []
