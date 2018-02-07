module Models exposing (..)


type alias Model =
    { route : Route
    }


type Route
    = LandingRoute
    | NewRoomRoute
    | NotFoundRoute
