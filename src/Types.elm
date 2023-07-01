module Types exposing (..)


type alias FrontendModel =
    { message : String
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
