module Evergreen.V4.Domain.Index exposing (..)

import Evergreen.V4.Api.Package
import Evergreen.V4.Domain.Dependency


type alias Index =
    { dependency : Evergreen.V4.Domain.Dependency.Dependency
    , packages : List Evergreen.V4.Api.Package.Package
    , slug : String
    }
