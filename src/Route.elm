module Route exposing (..)

import AppUrl exposing (AppUrl)
import Dict exposing (Dict)
import Url exposing (Url)


type Route
    = Search String


fromUrl : Url -> Maybe Route
fromUrl =
    AppUrl.fromUrl >> fromAppUrl


toString : Route -> String
toString route =
    case route of
        Search query ->
            AppUrl.toString
                { path = [ "search" ]
                , queryParameters =
                    Dict.fromList [ ( "q", [ query ] ) ]
                , fragment = Nothing
                }


fromAppUrl : AppUrl -> Maybe Route
fromAppUrl appUrl =
    case appUrl.path of
        [ "search" ] ->
            Dict.get "q" appUrl.queryParameters
                |> Maybe.andThen List.head
                |> Maybe.map Search

        _ ->
            Nothing


asSearchQuery : Route -> Maybe String
asSearchQuery route =
    case route of
        Search query ->
            Just query
