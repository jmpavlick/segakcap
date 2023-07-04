module Ui.Index exposing (view)

import Domain.Index exposing (Index)
import Element exposing (Element)
import Element.Font as Font
import Route
import Ui.Package


view : Index -> Element msg
view { dependency, packages } =
    Element.column [ Element.paddingEach { top = 0, bottom = 4, left = 0, right = 0 } ]
        [ Route.link [ Font.size 28 ]
            { route = Route.Search dependency.name
            , label = Element.text dependency.name
            }
        , Element.column [ Element.padding 10, Element.spacing 10 ] <| List.map Ui.Package.view packages
        ]
