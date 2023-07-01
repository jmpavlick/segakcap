module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V1.Api.Meta
import Evergreen.V1.Api.Package
import Http
import Lamdera
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , packages : List Evergreen.V1.Api.Package.Package
    , searchForm : String
    }


type alias BackendModel =
    { clients : List Lamdera.ClientId
    , packages : List Evergreen.V1.Api.Package.Package
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
    | GotMetaResponse (Result Http.Error (List Evergreen.V1.Api.Meta.Meta))
    | GotPackageResponse (Result Http.Error Evergreen.V1.Api.Package.Package)


type ToFrontend
    = GotPackages (List Evergreen.V1.Api.Package.Package)
