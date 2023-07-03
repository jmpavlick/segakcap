module Evergreen.V2.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V2.Api.Meta
import Evergreen.V2.Api.Package
import Evergreen.V2.Route
import Http
import Lamdera
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , route : Maybe Evergreen.V2.Route.Route
    , packages : List Evergreen.V2.Api.Package.Package
    }


type alias BackendModel =
    { clients : List Lamdera.ClientId
    , packages : List Evergreen.V2.Api.Package.Package
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UpdatedSearchForm String


type ToBackend
    = NoOpToBackend


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | ClientDisconnected Lamdera.SessionId Lamdera.ClientId
    | GotMetaResponse (Result Http.Error (List Evergreen.V2.Api.Meta.Meta))
    | GotPackageResponse (Result Http.Error Evergreen.V2.Api.Package.Package)


type ToFrontend
    = GotPackages (List Evergreen.V2.Api.Package.Package)
