module Frontend exposing (app)

import Lamdera


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = subscriptions
        , view =
            \model ->
                { title = "Lamdera"
                , body = [ view model ]
                }
        }
