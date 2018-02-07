module Main exposing (..)
import Models exposing (Model, Route)
import Navigation exposing (Location)
import Routing exposing (parseLocation)
import Messages exposing (..)
import View exposing (view)



main : Program Never Model Msg
main =
    Navigation.program Messages.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
--main : Html a
--main =
--  div [ class "elm-app" ] [ Views.Landing.view ]
init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location

    in
            ( initialModel currentRoute, Cmd.none )



initialModel : Route -> Model
initialModel route =
    {
        route = route
    }


--UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute }, Cmd.none )

        LandingMessage newMsg ->
            ( { model | route = Models.LandingRoute }, Cmd.none )