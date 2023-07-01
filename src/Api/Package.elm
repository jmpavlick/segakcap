module Api.Package exposing (..)

import Api.Dependency exposing (Dependency)
import Api.Meta exposing (Meta)
import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


type alias Package =
    { name : String
    , summary : String
    , license : String
    , version : String
    , exposedModules : List String
    , elmVersion : String
    , dependencies : Dict String String
    }


decoder : Decoder Package
decoder =
    Decode.succeed Package
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "summary" Decode.string
        |> Pipeline.required "license" Decode.string
        |> Pipeline.required "version" Decode.string
        |> Pipeline.required "exposed-modules" (Decode.list Decode.string)
        |> Pipeline.required "elm-version" Decode.string
        |> Pipeline.required "dependencies" (Decode.dict Decode.string)
