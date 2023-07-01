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
    , message : String
    , headers : ApiData (List Meta)
    }


type alias BackendModel =
    { message : String
    , headers : ApiData (List Meta)
    , dependencies : ApiData (List Dependency)
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


type ToFrontend
    = GotHeaders (ApiData (List Meta))
