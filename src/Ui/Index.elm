module Ui.Index exposing (view)

import Domain.Index exposing (Index)
import Element exposing (Element)
import Element.Font as Font
import Ui.Package


view : Index -> Element msg
view { dependency, packages } =
    Element.column [ Element.paddingEach { top = 0, bottom = 4, left = 0, right = 0 } ]
        [ Element.link [ Font.size 28 ]
            { url = "https://package.elm-lang.org/packages/" ++ dependency.name ++ "/latest/"
            , label = Element.text dependency.name
            }
        , Element.column [ Element.padding 10, Element.spacing 10 ] <| List.map Ui.Package.view packages
        ]
