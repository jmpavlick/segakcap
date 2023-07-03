module Types exposing (..)

import Api.Meta exposing (Meta)
import Api.Package exposing (Package)
import ApiData exposing (ApiData)
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import Lamdera exposing (ClientId, SessionId)
import Route exposing (Route)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , route : Maybe Route
    , packages : List Package
    }


type alias BackendModel =
    { clients : List ClientId
    , packages : List Package
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | UpdatedSearchForm String


type ToBackend
    = NoOpToBackend


type BackendMsg
    = ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId
    | GotMetaResponse (Result Http.Error (List Meta))
    | GotPackageResponse (Result Http.Error Package)


type ToFrontend
    = GotPackages (List Package)
