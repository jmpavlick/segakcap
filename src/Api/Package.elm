module Api.Package exposing (..)

import Api.Dependency exposing (Dependency)
import Api.Meta exposing (Meta)
import Json.Decode as Decode exposing (Decoder)


type alias Package =
    { meta : Meta
    , dependencies : List Dependency
    }
