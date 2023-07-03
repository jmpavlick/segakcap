module Route exposing (Route(..), asSearchQuery, fromUrl)

import AppUrl exposing (AppUrl)
import Dict
import Url exposing (Url)


type Route
    = Search String


fromUrl : Url -> Maybe Route
fromUrl =
    AppUrl.fromUrl >> fromAppUrl


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
