module Ui.Package exposing (..)

import Api.Package exposing (Package)
import Element exposing (Element)
import Element.Font as Font


view : Package -> Element msg
view package =
    Element.column []
        [ Element.link []
            { url = "https://package.elm-lang.org/packages/" ++ package.name ++ "/latest/"
            , label = Element.text <| package.name
            }
        , Element.el [] <| Element.text package.summary
        ]


viewGroup : { dependencyName : String, packages : List Package } -> Element msg
viewGroup { dependencyName, packages } =
    Element.column [ Element.paddingEach { top = 0, bottom = 4, left = 0, right = 0 } ]
        [ Element.link [ Font.size 28 ]
            { url = "https://package.elm-lang.org/packages/" ++ dependencyName ++ "/latest/"
            , label = Element.text <| dependencyName
            }
        , Element.column [ Element.padding 2 ] <| List.map view packages
        ]
