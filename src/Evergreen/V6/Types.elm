module Evergreen.V6.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V6.Api.Meta
import Evergreen.V6.Api.Package
import Evergreen.V6.Domain.Index
import Evergreen.V6.Route
import Http
import Lamdera
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , route : Maybe Evergreen.V6.Route.Route
    , indexes : List Evergreen.V6.Domain.Index.Index
    , orphanedPackges : List Evergreen.V6.Api.Package.Package
    }


type alias BackendModel =
    { clients : List Lamdera.ClientId
    , packages : List Evergreen.V6.Api.Package.Package
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
    | GotMetaResponse (Result Http.Error (List Evergreen.V6.Api.Meta.Meta))
    | GotPackageResponse (Result Http.Error Evergreen.V6.Api.Package.Package)


type ToFrontend
    = GotPackages (List Evergreen.V6.Api.Package.Package)
