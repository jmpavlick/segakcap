module Evergreen.V12.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V12.Api.Meta
import Evergreen.V12.Api.Package
import Evergreen.V12.Domain.Index
import Evergreen.V12.Route
import Http
import Lamdera
import Set
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , route : Maybe Evergreen.V12.Route.Route
    , indexes : List Evergreen.V12.Domain.Index.Index
    , orphanedPackges : List Evergreen.V12.Api.Package.Package
    }


type alias BackendModel =
    { clients : Set.Set Lamdera.ClientId
    , packages : List Evergreen.V12.Api.Package.Package
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
    | GotMetaResponse (Result Http.Error (List Evergreen.V12.Api.Meta.Meta))
    | GotPackageResponse (Result Http.Error Evergreen.V12.Api.Package.Package)
    | RefreshScheduleFired


type ToFrontend
    = GotPackages (List Evergreen.V12.Api.Package.Package)
