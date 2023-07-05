module Domain.Index exposing (Index, filter, orphanedPackages, refresh)

import Api.Package exposing (Package)
import Dict
import Domain.Dependency as Dependency exposing (Dependency)
import List.Extra as ListX


type alias Index =
    { dependency : Dependency
    , packages : List Package
    , slug : String
    }


refresh : List Package -> List Index
refresh packages =
    let
        packagesKeyed : List ( String, Package )
        packagesKeyed =
            List.sortBy .name packages
                |> List.concatMap
                    (\package ->
                        Dict.keys package.dependencies
                            |> List.filterMap
                                (\key ->
                                    if key == "elm/core" then
                                        Nothing

                                    else
                                        Just ( key, package )
                                )
                    )

        dependencies : List Dependency
        dependencies =
            List.map (Tuple.second >> Dependency.init) packagesKeyed

        join_ : List Dependency -> List ( String, Package ) -> List { dependency : Dependency, package : Package }
        join_ dependencies_ packages_ =
            ListX.joinOn
                (\dep pkg ->
                    { dependency = dep
                    , package = Tuple.second pkg
                    }
                )
                .name
                Tuple.first
                dependencies_
                packages_

        group : List { dependency : Dependency, package : Package } -> List Index
        group input =
            ListX.groupWhile
                (\a b ->
                    a.dependency.name == b.dependency.name
                )
                input
                |> List.map
                    (\( x, xs ) ->
                        { dependency = x.dependency
                        , packages =
                            x.package
                                :: List.map .package xs
                                |> ListX.uniqueBy .name
                                |> List.sortBy .slug
                        , slug = String.toLower x.dependency.name
                        }
                    )
    in
    join_
        dependencies
        packagesKeyed
        |> group


filter : List Index -> String -> List Index
filter indexes query =
    List.filter
        (\index -> String.contains (String.toLower query) index.slug)
        indexes
        |> List.sortBy (\i -> List.length i.packages)
        |> List.reverse


orphanedPackages : List Index -> List Package -> List Package
orphanedPackages index packages =
    let
        indexedPackageNames : List String
        indexedPackageNames =
            List.map .dependency index |> List.map .name |> List.sort
    in
    List.sortBy .name packages
        |> ListX.filterNot (\p -> List.member p.name indexedPackageNames)
