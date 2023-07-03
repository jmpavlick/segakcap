module Ui.View exposing (view)

import Domain.Index as Index exposing (Index)
import Element exposing (Element)
import Element.Input as Input
import Ui.Index


searchForm : (String -> msg) -> String -> Element msg
searchForm toMsg input =
    Input.text []
        { onChange = toMsg
        , text = input
        , placeholder = Nothing
        , label = Input.labelHidden "Search form"
        }


view :
    { indexes : List Index
    , query : Maybe String
    , searchMsg : String -> msg
    }
    -> Element msg
view { indexes, query, searchMsg } =
    Element.column []
        [ searchForm searchMsg <| Maybe.withDefault "" query
        , Maybe.map
            (\q ->
                Element.column [ Element.spacingXY 0 10 ] <|
                    List.map Ui.Index.view <|
                        Index.filter indexes q
            )
            (Maybe.andThen
                (\q ->
                    if String.length q > 2 then
                        Just q

                    else
                        Nothing
                )
                query
            )
            |> Maybe.withDefault
                (Element.text "Enter a package name to search for packages that have it as a dependency.")
        ]
