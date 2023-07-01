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


filter : List Package -> String -> List { dependencyName : String, packages : List Package }
filter packages searchForm =
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
            if String.contains (String.toLower searchForm) (String.toLower dep) then
                Just ( dep, package )

            else
                Nothing
        )
        index
        |> ListX.unique
        |> List.sortBy (Tuple.first >> String.toLower)
        |> ListX.groupWhile (\d1 d2 -> Tuple.first d1 == Tuple.first d2)
        |> List.map
            (\( x, xs ) ->
                { dependencyName = Tuple.first x
                , packages = List.sortBy .name <| List.map Tuple.second (x :: xs)
                }
            )
        |> List.sortBy (\item -> List.length item.packages)
        |> List.reverse
