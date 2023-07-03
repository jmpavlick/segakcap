module Domain.Dependency exposing (Dependency, init)

import Api.Package exposing (Package)


type alias Dependency =
    { name : String
    , summary : String
    }


init : Package -> Dependency
init package =
    { name = package.name
    , summary = package.summary
    }
