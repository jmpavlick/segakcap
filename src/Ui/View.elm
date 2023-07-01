module Ui.View exposing (..)

import Api.Package as Package exposing (Package)
import Element exposing (Element)
import Element.Input as Input
import Ui.Package


searchForm : (String -> msg) -> String -> Element msg
searchForm toMsg input =
    Input.text []
        { onChange = toMsg
        , text = input
        , placeholder = Nothing
        , label = Input.labelHidden "Search form"
        }


view :
    { packages : List Package
    , searchFormInput : String
    , searchMsg : String -> msg
    }
    -> Element msg
view { packages, searchFormInput, searchMsg } =
    Element.column []
        [ searchForm searchMsg searchFormInput
        , if String.length searchFormInput > 0 then
            Element.column [ Element.spacingXY 0 10 ] <|
                List.map Ui.Package.viewGroup <|
                    Package.filter packages searchFormInput

          else
            Element.text "Enter a package name to search for packages that have it as a dependency."
        ]
