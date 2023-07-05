module Evergreen.V6.Api.Package exposing (..)

import Dict


type alias Package =
    { name : String
    , slug : String
    , summary : String
    , license : String
    , version : String
    , exposedModules : List String
    , elmVersion : String
    , dependencies : Dict.Dict String String
    }
