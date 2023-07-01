module Api.Package exposing (..)

import Api.Dependency exposing (Dependency)
import Api.Meta exposing (Meta)
import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import List.Extra as ListX


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


filter : List Package -> String -> List ( String, Package )
filter packages dependencyName =
    let
        index : List ( String, Package )
        index =
            List.concatMap
                (\package ->
                    Dict.keys package.dependencies
                        |> List.map (\key -> ( key, package ))
                )
                packages
    in
    List.filterMap
        (\( dep, package ) ->
            if String.contains dependencyName dep then
                Just ( dep, package )

            else
                Nothing
        )
        index
        |> ListX.unique
