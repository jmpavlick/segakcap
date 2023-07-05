module Ui.View exposing (view)

import Api.Package as Package exposing (Package)
import Domain.Index as Index exposing (Index)
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import List.Extensions as ListE
import Maybe.Extra as MaybeX
import Route
import Ui.Index
import Ui.Package



-- VIEW, FRAME


color :
    { white : Element.Color
    , blue : Element.Color
    , lightGray : Element.Color
    , black : Element.Color
    }
color =
    { white = Element.rgb255 0xFF 0xFF 0xFF
    , blue = Element.rgb255 0x5F 0xAB 0xDC
    , lightGray = Element.rgb255 0xBB 0xBB 0xBB
    , black = Element.rgb255 0x00 0x0E 0x16
    }


fontSize :
    { title : Element.Attr decorative msg
    , small : Element.Attr decorative msg
    , body : Element.Attr decorative msg
    }
fontSize =
    { title = Font.size 28
    , small = Font.size 16
    , body = Font.size 20
    }


view :
    { indexes : List Index
    , orphanedPackages : List Package
    , query : Maybe String
    , searchMsg : String -> msg
    }
    -> Element msg
view params =
    Element.column
        [ Element.width Element.fill, Font.color color.black ]
        [ frame
            { header_ = header
            , body_ = body params
            , footer_ = footer
            }
        ]


frame :
    { header_ : Element msg
    , body_ : Element msg
    , footer_ : Element msg
    }
    -> Element msg
frame { header_, body_, footer_ } =
    Element.column [ Element.spacing 8, Element.width Element.fill ]
        [ header_
        , body_
        , footer_
        ]



-- HEADER


header : Element msg
header =
    Element.row
        [ Element.width Element.fill
        , Background.color color.blue
        ]
        [ Element.el [ Element.width <| Element.fillPortion 2 ] Element.none
        , Element.row
            [ Font.color color.white
            , Element.width <| Element.fillPortion 6
            , Element.spacing 10
            , Element.padding 4
            ]
            [ Route.link []
                { route = Route.Home
                , label =
                    Element.image [ Element.width <| Element.px 50, Element.height <| Element.px 50 ]
                        { src = "/logo.svg", description = "segakcap logo" }
                }
            , Element.column []
                [ Element.el [ fontSize.title ] <| Element.text "segakcap"
                , Element.el [ fontSize.small ] <| Element.text "elm reverse package search"
                ]
            ]
        , Element.el [ Element.width <| Element.fillPortion 2 ] Element.none
        ]



-- BODY


body :
    { indexes : List Index
    , orphanedPackages : List Package
    , query : Maybe String
    , searchMsg : String -> msg
    }
    -> Element msg
body { indexes, orphanedPackages, query, searchMsg } =
    Element.row [ Element.width Element.fill ]
        [ Element.el [ Element.width <| Element.fillPortion 2 ] Element.none
        , Element.column [ Element.spacing 4, Element.width <| Element.fillPortion 6 ]
            [ Element.el [ Element.width Element.fill ] <| searchForm searchMsg <| Maybe.withDefault "" query
            , Maybe.map (results { indexes = indexes, orphanedPackages = orphanedPackages }) query
                |> Maybe.withDefault default
            ]
        , Element.el [ Element.width <| Element.fillPortion 2 ] Element.none
        ]


results : { indexes : List Index, orphanedPackages : List Package } -> String -> Element msg
results { indexes, orphanedPackages } query =
    MaybeX.orListLazy
        [ \() -> matchingIndexes query indexes
        , \() -> matchingOrphanedPackages query orphanedPackages
        , \() ->
            if List.isEmpty indexes || List.isEmpty orphanedPackages then
                Just <| Element.el [ Font.color color.lightGray ] <| Element.text "Loading..."

            else
                Just noMatches
        ]
        |> Maybe.withDefault Element.none


matchingIndexes : String -> List Index -> Maybe (Element msg)
matchingIndexes query indexes =
    Index.filter indexes query
        |> Debug.log "filtered indexes"
        |> ListE.mapNonEmpty Ui.Index.view
        |> Maybe.map (Element.column [ Element.spacingXY 0 10 ])


matchingOrphanedPackages : String -> List Package -> Maybe (Element msg)
matchingOrphanedPackages query packages =
    Package.filter packages query
        |> ListE.mapNonEmpty Ui.Package.view
        |> Maybe.map
            (\orphanedViews ->
                Element.column [ Element.spacing 4 ]
                    [ Element.el [ Element.centerX ] <| Element.text "None of the packages matching your query are a dependency of any other packages - but here they are:"
                    , Element.column [ Element.spacingXY 0 10 ] orphanedViews
                    ]
            )


noMatches : Element msg
noMatches =
    Element.el [] <| Element.text "No packages match your query."


default : Element msg
default =
    Element.column [ Element.centerX, Element.spacing 4 ]
        [ Element.text "Enter a package name to search for packages that have it as a dependency."
        , Element.el [ Element.centerX ] <| Element.text "Here are some popular ones:"
        , featuredPackageLink "jfmengels/elm-review"
        , featuredPackageLink "mdgriffith/elm-ui"
        ]


featuredPackageLink : String -> Element msg
featuredPackageLink name =
    Element.el [ Element.centerX ] <|
        bullet <|
            Route.link []
                { label = Element.el [ Font.underline ] <| Element.text name
                , route = Route.Search name
                }


bullet : Element msg -> Element msg
bullet elem =
    Element.row [ Element.centerY, Element.spacing 8 ] [ Element.text "•", elem ]


searchForm : (String -> msg) -> String -> Element msg
searchForm toMsg input =
    Input.text [ Element.width Element.fill ]
        { onChange = toMsg
        , text = input
        , placeholder = Just <| Input.placeholder [ Font.italic ] <| Element.text "Search"
        , label = Input.labelHidden "Search form"
        }



-- FOOTER


footer : Element msg
footer =
    Element.row [ Element.centerX, fontSize.small, Font.color color.lightGray ]
        [ Element.text "made with love for the elm community by "
        , Element.newTabLink [] { url = "https://twitter.com/lambdapriest", label = Element.el [ Font.underline ] <| Element.text "@lambdapriest" }
        ]
