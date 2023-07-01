module Backend exposing (..)

import Api.Meta as Meta exposing (Meta)
import Api.Package as Package exposing (Package)
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
    ( { clients = []
      , packages = []
      }
    , getMeta
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected _ clientId ->
            ( { model | clients = clientId :: model.clients }
            , Cmd.batch
                [ Lamdera.sendToFrontend clientId <| GotPackages model.packages
                , getMeta
                ]
            )

        ClientDisconnected _ clientId ->
            ( { model | clients = List.filter (\c -> c /= clientId) model.clients }
            , Cmd.none
            )

        GotMetaResponse response ->
            ( model
            , Result.map
                (\okMetas ->
                    filterMetasToUpdate model.packages okMetas
                        |> Debug.log "filtered metas"
                        |> getDependencies
                        |> Cmd.batch
                )
                response
                |> Result.withDefault Cmd.none
            )

        GotPackageResponse package ->
            ( { model
                | packages =
                    Result.toMaybe package
                        |> Debug.log "package response"
                        |> Maybe.map (\p -> p :: model.packages)
                        |> Maybe.withDefault model.packages
              }
            , Cmd.none
            )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )


getMeta : Cmd BackendMsg
getMeta =
    Http.get
        { url = "https://package.elm-lang.org/search.json"
        , expect = Http.expectJson GotMetaResponse (Decode.list Meta.decoder)
        }


getDependencies : List Meta -> List (Cmd BackendMsg)
getDependencies metas =
    List.map
        (\meta ->
            Http.get
                { url = "https://package.elm-lang.org/packages/" ++ meta.name ++ "/" ++ meta.version ++ "/elm.json"
                , expect = Http.expectJson GotPackageResponse Package.decoder
                }
        )
        metas


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        , Lamdera.onDisconnect ClientDisconnected
        ]


filterMetasToUpdate : List Package -> List Meta -> List Meta
filterMetasToUpdate packages metas =
    let
        packageMetas : List Meta
        packageMetas =
            List.map (\p -> { name = p.name, version = p.version }) packages
    in
    List.filter
        (\meta ->
            not <| List.member meta packageMetas
        )
        metas
