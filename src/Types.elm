module Types exposing (..)

import Api.Dependency as Dependency exposing (Dependency)
import Api.Meta as Header exposing (Meta)
import ApiData exposing (ApiData)
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import Lamdera exposing (ClientId, SessionId)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , headers : ApiData (List Meta)
    }


type alias BackendModel =
    { headers : ApiData (List Meta)
    , dependencies : ApiData (List Dependency)
    , clients : List ClientId
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = RequestedAllHeaders (Result Http.Error (List Meta))
    | ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId
    | SyncFired


type ToFrontend
    = GotHeaders (ApiData (List Meta))
