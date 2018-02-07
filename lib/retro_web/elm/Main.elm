module Main exposing (..)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Views.Landing


main : Html a
main =
  div [ class "elm-app" ] [ Views.Landing.view ]
