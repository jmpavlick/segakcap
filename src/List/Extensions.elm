module List.Extensions exposing (mapNonEmpty)


mapNonEmpty : (a -> b) -> List a -> Maybe (List b)
mapNonEmpty func list =
    if List.isEmpty list == False then
        Just <| List.map func list

    else
        Nothing
