module Route exposing (Route(..), asSearchQuery, fromUrl, link)

import AppUrl exposing (AppUrl)
import Dict
import Element exposing (Element)
import Url exposing (Url)


type Route
    = Search String
    | Home


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

        [] ->
            Just Home

        _ ->
            Nothing


asSearchQuery : Route -> Maybe String
asSearchQuery route =
    case route of
        Search query ->
            if String.isEmpty query then
                Nothing

            else
                Just query

        _ ->
            Nothing


toUrlString : Route -> String
toUrlString route =
    case route of
        Search query ->
            "/search?q=" ++ query

        Home ->
            "/"


link : List (Element.Attribute msg) -> { label : Element msg, route : Route } -> Element msg
link attrs { label, route } =
    Element.link attrs { url = toUrlString route, label = label }
