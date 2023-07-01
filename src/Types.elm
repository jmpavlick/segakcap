module Types exposing (..)

import Api.Meta exposing (Meta)
import Api.Package exposing (Package)
import ApiData exposing (ApiData)
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import Lamdera exposing (ClientId, SessionId)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , packages : List Package
    }


type alias BackendModel =
    { clients : List ClientId
    , packages : List Package
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId
    | GotMetaResponse (Result Http.Error (List Meta))
    | GotPackageResponse (Result Http.Error Package)


type ToFrontend
    = GotPackages (List Package)
