module Api.Meta exposing (Meta, decoder)

import Json.Decode as Decode exposing (Decoder)


type alias Meta =
    { name : String
    , summary : String
    , license : String
    , version : String
    }


decoder : Decoder Meta
decoder =
    Decode.map4 Meta
        (Decode.field "name" Decode.string)
        (Decode.field "summary" Decode.string)
        (Decode.field "license" Decode.string)
        (Decode.field "version" Decode.string)
