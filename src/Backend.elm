module Backend exposing (..)

import Api.Meta as Header
import ApiData
import Http
import Json.Decode as Decode
import Lamdera exposing (ClientId, SessionId)
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
    ( { message = "Hello!"
      , headers = ApiData.NotAsked
      , dependencies = ApiData.NotAsked
      }
    , getAllHeaders
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected _ clientId ->
            ( model
            , Lamdera.sendToFrontend clientId <| GotHeaders model.headers
            )

        RequestedAllHeaders apiData ->
            ( { model | headers = ApiData.fromResult apiData }
            , Cmd.none
            )
                |> Debug.log "requested all headers"


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
        |> Debug.log "requested all headers"



--getDependencies :


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        ]
