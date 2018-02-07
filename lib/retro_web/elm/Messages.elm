module Messages exposing (..)

import Navigation exposing (Location)
import Views.Landing exposing (Msg)


type Msg
    = LandingMessage Views.Landing.Msg
    | OnLocationChange Location