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
