module Backend exposing (..)

import Api.Meta as Header
import ApiData
import Http
import Json.Decode as Decode
import Lamdera exposing (ClientId, SessionId)
import Time
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { headers = ApiData.Loading
      , dependencies = ApiData.NotAsked
      , clients = []
      }
    , getAllHeaders |> Debug.log "getAllHeaders fired from init"
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected _ clientId ->
            ( { model | clients = clientId :: model.clients }
            , Lamdera.sendToFrontend clientId <| GotHeaders model.headers
            )

        ClientDisconnected _ clientId ->
            ( { model | clients = List.filter (\c -> c /= clientId) model.clients }
            , Cmd.none
            )

        RequestedAllHeaders apiData ->
            ( { model | headers = ApiData.fromResult apiData |> Debug.log "headers output" }
            , Cmd.none
            )

        SyncFired ->
            ( model
            , List.map (\c -> Lamdera.sendToFrontend c <| GotHeaders model.headers) model.clients
                |> Cmd.batch
            )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )


getAllHeaders : Cmd BackendMsg
getAllHeaders =
    Http.get
        { url = "https://package.elm-lang.org/search.json"
        , expect = Http.expectJson RequestedAllHeaders (Decode.list Header.decoder)
        }



--getDependencies :


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        , Lamdera.onDisconnect ClientDisconnected

        --, Time.every 1000 (always SyncFired)
        ]
