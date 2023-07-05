module Evergreen.V6.Domain.Index exposing (..)

import Evergreen.V6.Api.Package
import Evergreen.V6.Domain.Dependency


type alias Index =
    { dependency : Evergreen.V6.Domain.Dependency.Dependency
    , packages : List Evergreen.V6.Api.Package.Package
    , slug : String
    }
