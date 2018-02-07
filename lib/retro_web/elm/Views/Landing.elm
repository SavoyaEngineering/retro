module Views.Landing exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Models exposing (Model, Route(NewRoomRoute))
import Navigation
import Routing exposing (newRoomPath)
import Debug exposing(log)


type Msg
    = LandingMsg
    | GoToNewRoom


update : Msg -> Model ->( Model, Cmd Msg )
update msg model =
    case msg of
        GoToNewRoom ->
            (model, Navigation.load newRoomPath )
        LandingMsg ->
            (model,  Cmd.none )

view : Html Msg
view =
    div [class "jumbotron"]
        [ h2 []
            [ text "Start or join a retro"],
          button [class "btn btn-primary",  onClick GoToNewRoom] [ text "Create a Retro" ],
          button [class "btn btn-primary", href "/rooms"] [text "Join a Retro"]
        ]
