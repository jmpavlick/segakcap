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
        , if String.length searchFormInput > 2 then
            Element.column [] <|
                List.map Ui.Package.view <|
                    List.map Tuple.second <|
                        List.sortBy (Tuple.second >> .name) <|
                            Package.filter packages searchFormInput

          else
            Element.text "Enter a package name to search for packages that have it as a dependency."
        ]
