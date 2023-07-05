module Evergreen.V8.Domain.Index exposing (..)

import Evergreen.V8.Api.Package
import Evergreen.V8.Domain.Dependency


type alias Index =
    { dependency : Evergreen.V8.Domain.Dependency.Dependency
    , packages : List Evergreen.V8.Api.Package.Package
    , slug : String
    }
