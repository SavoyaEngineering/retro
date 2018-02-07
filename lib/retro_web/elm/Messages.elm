module Messages exposing (..)

import Navigation exposing (Location)
import Views.Landing exposing (Msg)
import Views.NewRoom exposing (Msg)


type Msg
    = LandingMessage Views.Landing.Msg
    | NewRoomMessage Views.NewRoom.Msg
    | OnLocationChange Location