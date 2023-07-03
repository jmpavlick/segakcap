module Ui.Package exposing (view)

import Api.Package exposing (Package)
import Element exposing (Element)
import Element.Font as Font


view : Package -> Element msg
view package =
    Element.column []
        [ Element.link []
            { url = "https://package.elm-lang.org/packages/" ++ package.name ++ "/latest/"
            , label = Element.el [ Font.underline ] <| Element.text package.name
            }
        , Element.el [] <| Element.text package.summary
        ]
