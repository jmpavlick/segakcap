module Backend exposing (Model, app)

import Api.Meta as Meta exposing (Meta)
import Api.Package as Package exposing (Package)
import Http
import Json.Decode as Decode
import Lamdera exposing (ClientId, SessionId)
import Set
import Time
import Types exposing (BackendModel, BackendMsg(..), ToBackend(..), ToFrontend(..))


type alias Model =
    BackendModel


app :
    { init : ( Model, Cmd BackendMsg )
    , update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
    , updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
    , subscriptions : Model -> Sub BackendMsg
    }
app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = always subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { clients = Set.empty
      , packages = []
      }
    , getMeta
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected _ clientId ->
            ( { model | clients = Set.insert clientId model.clients }
            , Lamdera.sendToFrontend clientId <| GotPackages model.packages
            )

        ClientDisconnected _ clientId ->
            ( { model | clients = Set.remove clientId model.clients }
            , Cmd.none
            )

        GotMetaResponse response ->
            ( model
            , Result.map
                (\okMetas ->
                    filterMetasToUpdate model.packages okMetas
                        |> getDependencies
                        |> Cmd.batch
                )
                response
                |> Result.withDefault Cmd.none
            )

        GotPackageResponse package ->
            let
                packages_ : List Package
                packages_ =
                    Result.toMaybe package
                        |> Maybe.map (\p -> p :: model.packages)
                        |> Maybe.withDefault model.packages
            in
            ( { model
                | packages = packages_
              }
            , Cmd.none
            )

        RefreshScheduleFired ->
            ( model
            , getMeta
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


subscriptions : Sub BackendMsg
subscriptions =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        , Lamdera.onDisconnect ClientDisconnected
        , Time.every (1000 * 60 * 5) (always RefreshScheduleFired)
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
