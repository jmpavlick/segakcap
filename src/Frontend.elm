module Frontend exposing (Model, app)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Domain.Index as Index
import Element
import Lamdera
import Route
import Types exposing (FrontendModel, FrontendMsg(..), ToFrontend(..))
import Ui.View as View
import Url


type alias Model =
    FrontendModel


app :
    { init : Lamdera.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
    , view : Model -> Browser.Document FrontendMsg
    , update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
    , updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
    , subscriptions : Model -> Sub FrontendMsg
    , onUrlRequest : UrlRequest -> FrontendMsg
    , onUrlChange : Url.Url -> FrontendMsg
    }
app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \_ -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , route = Route.fromUrl url
      , indexes = []
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( { model | route = Route.fromUrl url }
            , Cmd.none
            )

        UpdatedSearchForm query ->
            ( { model | route = Just <| Route.Search query }
            , Cmd.none
            )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        GotPackages packages ->
            ( { model | indexes = Index.refresh packages }, Cmd.none )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = "segakcap: reverse dependency search for Elm packages"
    , body =
        [ Element.layout
            [ Element.width Element.fill ]
          <|
            Element.el [ Element.width Element.fill, Element.centerX ] <|
                View.view
                    { searchMsg = UpdatedSearchForm
                    , query = Maybe.andThen Route.asSearchQuery model.route
                    , indexes = model.indexes
                    }
        ]
    }
