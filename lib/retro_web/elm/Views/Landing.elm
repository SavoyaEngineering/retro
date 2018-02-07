module Views.Landing exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href)


view : Html a
view =
    div [class "jumbotron"]
        [ h2 []
            [ text "Start or join a retro"],
          a [class "btn btn-primary", href "/rooms/new"] [text "Create a Retro"],
          a [class "btn btn-primary", href "/rooms"] [text "Join a Retro"]
        ]
