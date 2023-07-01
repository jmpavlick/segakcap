module Api.Meta exposing (Meta, decoder)

import Json.Decode as Decode exposing (Decoder)


type alias Meta =
    { name : String
    , version : String
    }


decoder : Decoder Meta
decoder =
    Decode.map2 Meta
        (Decode.field "name" Decode.string)
        (Decode.field "version" Decode.string)
