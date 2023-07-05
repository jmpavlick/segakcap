module Evergreen.V8.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V8.Api.Meta
import Evergreen.V8.Api.Package
import Evergreen.V8.Domain.Index
import Evergreen.V8.Route
import Http
import Lamdera
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , route : Maybe Evergreen.V8.Route.Route
    , indexes : List Evergreen.V8.Domain.Index.Index
    , orphanedPackges : List Evergreen.V8.Api.Package.Package
    }


type alias BackendModel =
    { clients : List Lamdera.ClientId
    , packages : List Evergreen.V8.Api.Package.Package
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
    | GotMetaResponse (Result Http.Error (List Evergreen.V8.Api.Meta.Meta))
    | GotPackageResponse (Result Http.Error Evergreen.V8.Api.Package.Package)
    | RefreshScheduleFired


type ToFrontend
    = GotPackages (List Evergreen.V8.Api.Package.Package)
