module Api.Package exposing (Package, decoder, filter)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


type alias Package =
    { name : String
    , slug : String
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
        |> Pipeline.required "name" (Decode.map String.toLower Decode.string)
        |> Pipeline.required "summary" (Decode.map String.trim Decode.string)
        |> Pipeline.required "license" Decode.string
        |> Pipeline.required "version" Decode.string
        |> Pipeline.required "exposed-modules" (Decode.list Decode.string)
        |> Pipeline.required "elm-version" Decode.string
        |> Pipeline.required "dependencies" (Decode.dict Decode.string)


filter : List Package -> String -> List Package
filter packages query =
    List.filter
        (\package -> String.contains (String.toLower query) package.slug)
        packages
