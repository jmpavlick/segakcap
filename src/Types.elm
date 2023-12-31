module Types exposing (BackendModel, BackendMsg(..), FrontendModel, FrontendMsg(..), ToBackend(..), ToFrontend(..))

import Api.Meta exposing (Meta)
import Api.Package exposing (Package)
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Domain.Index exposing (Index)
import Http
import Lamdera exposing (ClientId, SessionId)
import Route exposing (Route)
import Set exposing (Set)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , route : Maybe Route
    , indexes : List Index
    , orphanedPackges : List Package
    }


type alias BackendModel =
    { clients : Set ClientId
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
    | RefreshScheduleFired


type ToFrontend
    = GotPackages (List Package)
