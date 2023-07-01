module ApiData exposing (..)

import Http


type ApiData a
    = NotAsked
    | Loading
    | Loaded a
    | Failed Http.Error


fromResult : Result Http.Error a -> ApiData a
fromResult result =
    case result of
        Ok a ->
            Loaded a

        Err x ->
            Failed x


toMaybe : ApiData a -> Maybe a
toMaybe apiData =
    case apiData of
        Loaded a ->
            Just a

        _ ->
            Nothing


map : (a -> b) -> ApiData a -> ApiData b
map func value =
    case value of
        Loaded a ->
            Loaded <| func a

        NotAsked ->
            NotAsked

        Loading ->
            Loading

        Failed x ->
            Failed x
