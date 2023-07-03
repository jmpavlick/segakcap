module Evergreen.V2.Domain.Index exposing (..)

import Evergreen.V2.Api.Package
import Evergreen.V2.Domain.Dependency


type alias Index =
    { dependency : Evergreen.V2.Domain.Dependency.Dependency
    , packages : List Evergreen.V2.Api.Package.Package
    , slug : String
    }
