module Ui.Package exposing (..)

import Api.Package exposing (Package)
import Element exposing (Element)


view : Package -> Element msg
view package =
    Element.column []
        [ Element.link []
            { url = "https://package.elm-lang.org/packages/" ++ package.name ++ "/latest/"
            , label = Element.text <| package.name
            }
        ]


viewGroup : { dependencyName : String, packages : List Package } -> Element msg
viewGroup { dependencyName, packages } =
    Element.column []
        [ Element.el [] <| Element.text dependencyName
        , Element.column [] <| List.map view packages
        ]
