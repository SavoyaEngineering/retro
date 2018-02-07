module Routing exposing (..)

import Models exposing (Route(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LandingRoute top,
          map NewRoomRoute (s "new_room")
        ]


parseLocation : Location -> Route
parseLocation location =
    case parseHash matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


landingPath : String
landingPath =
    ""

newRoomPath : String
newRoomPath =
    "#new_room"