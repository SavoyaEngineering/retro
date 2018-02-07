module Main exposing (..)
import Models exposing (Model, Route)
import Navigation exposing (Location)
import Routing exposing (parseLocation)
import Messages exposing (..)
import View exposing (view)
import Views.Landing



main : Program Never Model Msg
main =
    Navigation.program Messages.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


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
        LandingMessage subMsg ->
            let
                nextCmd = Views.Landing.update subMsg model
            in
            ( Tuple.first nextCmd, Cmd.map LandingMessage <| Tuple.second nextCmd )
        NewRoomMessage newMsg ->
            ( { model | route = Models.LandingRoute }, Cmd.none )