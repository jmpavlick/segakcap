module Api.Dependency exposing (..)

import Api.Meta as Header exposing (Meta)
import Json.Decode as Decode exposing (Decoder)


type alias Dependency =
    { name : String
    , versionRange : String
    }


decoder : Decoder Dependency
decoder =
    Decode.map2 Dependency
        (Decode.field "name" Decode.string)
        (Decode.field "version" Decode.string)
