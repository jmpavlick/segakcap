module Evergreen.V12.Domain.Index exposing (..)

import Evergreen.V12.Api.Package
import Evergreen.V12.Domain.Dependency


type alias Index =
    { dependency : Evergreen.V12.Domain.Dependency.Dependency
    , packages : List Evergreen.V12.Api.Package.Package
    , slug : String
    }
