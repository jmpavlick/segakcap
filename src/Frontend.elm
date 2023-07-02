module Frontend exposing (..)

import ApiData
import AppUrl
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element
import Html
import Html.Attributes as Attr
import Lamdera
import Route exposing (Route)
import Types exposing (..)
import Ui.View as View
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , packages = []
      , route = Route.fromUrl url
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
            ( model
            , Nav.pushUrl model.key (Url.toString url)
            )

        UpdatedSearchForm query ->
            ( { model | route = Just <| Route.Search query }
              --model
              --, Nav.pushUrl model.key (Route.toString <| Route.Search query)
            , Cmd.none
            )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        GotPackages packages ->
            ( { model | packages = packages }, Cmd.none )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = "segakcap: reverse dependency search for Elm packages"
    , body =
        [ Element.layout
            []
          <|
            View.view
                { searchMsg = UpdatedSearchForm
                , searchQuery = Maybe.andThen Route.asSearchQuery model.route
                , packages = model.packages
                }
        ]
    }
