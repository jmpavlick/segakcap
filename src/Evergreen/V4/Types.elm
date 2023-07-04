module Evergreen.V4.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V4.Api.Meta
import Evergreen.V4.Api.Package
import Evergreen.V4.Domain.Index
import Evergreen.V4.Route
import Http
import Lamdera
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , route : Maybe Evergreen.V4.Route.Route
    , indexes : List Evergreen.V4.Domain.Index.Index
    }


type alias BackendModel =
    { clients : List Lamdera.ClientId
    , packages : List Evergreen.V4.Api.Package.Package
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
    | GotMetaResponse (Result Http.Error (List Evergreen.V4.Api.Meta.Meta))
    | GotPackageResponse (Result Http.Error Evergreen.V4.Api.Package.Package)


type ToFrontend
    = GotPackages (List Evergreen.V4.Api.Package.Package)
