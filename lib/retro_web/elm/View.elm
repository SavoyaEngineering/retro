module View exposing (..)

import Html exposing (Html, div, map, p, text)
import Html.Attributes exposing (class)
import Models exposing (Model)
import Messages exposing (Msg)
import Views.Landing


view : Model -> Html Msg
view model =
    let
        viewToBeSet =
            case model.route of
                Models.LandingRoute ->
                    map Messages.LandingMessage (Views.Landing.view)
                Models.NotFoundRoute ->
                    notFoundView
    in
    div [ class "container" ] [ viewToBeSet ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
