module ReviewConfig exposing (config)

import CognitiveComplexity
import NoBooleanCase
import NoDeprecated
import NoDuplicatePorts
import NoEmptyText
import NoExposingEverything
import NoFloatIds
import NoImportingEverything
import NoInconsistentAliases
import NoLeftPizza
import NoLongImportLines
import NoMissingSubscriptionsCall
import NoMissingTypeAnnotation
import NoMissingTypeAnnotationInLetIn
import NoMissingTypeConstructor
import NoMissingTypeExpose
import NoModuleOnExposedNames
import NoPrematureLetComputation
import NoRecursiveUpdate
import NoRedundantConcat
import NoRedundantCons
import NoSimpleLetBody
import NoSinglePatternCase
import NoTypeAliasConstructorCall
import NoUnmatchedUnit
import NoUnoptimizedRecursion
import NoUnsafePorts
import NoUnused.CustomTypeConstructorArgs
import NoUnused.CustomTypeConstructors
import NoUnused.Dependencies
import NoUnused.Exports
import NoUnused.Modules
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import NoUnusedPorts
import NoUselessSubscriptions
import Review.Rule as Rule exposing (Rule)
import ReviewPipelineStyles
import ReviewPipelineStyles.Premade as PremadePipelineRule
import Simplify
import UseCamelCase


{-| `elm-review` config
-}
config : List Rule
config =
    [ -- Check cognitive complexity (branching, not branches) of code
      CognitiveComplexity.rule 25

    -- Disallow pattern matching on boolean values.
    , NoBooleanCase.rule

    -- Forbid use of deprecated functions
    , NoDeprecated.rule NoDeprecated.defaults

    -- Ensure port names are unique within a project
    , NoDuplicatePorts.rule

    -- Forbid `Html.text ""` instead of `HtmlX.nothing`
    , NoEmptyText.rule

    -- Forbid `module A exposing (..)`
    , NoExposingEverything.rule

    -- Detect use of `Float`s as ids
    , NoFloatIds.rule

    -- Forbid `import A exposing (..)`
    , NoImportingEverything.rule []

    -- Ensure consistent import aliases and enforce their use
    , NoInconsistentAliases.config
        [ ( "Array.Extra", "ArrayX" )
        , ( "Element.Border", "Border" )
        , ( "Element.Font", "Font" )
        , ( "Element.Input", "Input" )
        , ( "Element.Region", "Region" )
        , ( "Html", "HtmlU" )
        , ( "Json.Decode", "Decode" )
        , ( "Json.Encode", "Encode" )
        , ( "Markdown.Block", "Block" )
        , ( "Markdown.Extensions", "MarkdownE" )
        , ( "Markdown.Html", "MHtml" )
        , ( "Markdown.Parser", "Parser" )
        , ( "Markdown.Renderer", "Renderer" )
        ]
        |> NoInconsistentAliases.noMissingAliases
        |> NoInconsistentAliases.rule

    -- Forbid import lines longer than 120 characters
    , NoLongImportLines.rule

    -- Reports likely missing calls to a `subscriptions` function.
    , NoMissingSubscriptionsCall.rule
        |> Rule.ignoreErrorsForDirectories
            [ "tests/"
            ]

    -- Forbid missing type annotations for TLDs
    , NoMissingTypeAnnotation.rule

    -- Forbid missing type annotations in let expressions
    , NoMissingTypeAnnotationInLetIn.rule

    -- Report missing constructors for lists of all constructors, e.g. `Color = Red | Blue | Green` will error with `[Red, Blue]`
    , NoMissingTypeConstructor.rule

    -- Forbid not exposing the type for any types that appear in exported functions or values
    , NoMissingTypeExpose.rule
        |> Rule.ignoreErrorsForFiles [ "src/Main.elm" ]

    -- Disallow qualified use of names imported unqualified
    , NoModuleOnExposedNames.rule

    -- Forbid let declarations that are computed earlier than needed
    , NoPrematureLetComputation.rule

    -- Forbid calling `update` within `update`
    , NoRecursiveUpdate.rule

    -- Warn about unnecessary `++`'s, e.g. `[a] ++ [b]` instead of `[a, b]`
    , NoRedundantConcat.rule

    -- Forbids consing to a literal list, e.g. `foo::[bar]` instead of `[foo,bar]`
    , NoRedundantCons.rule

    -- Forbid `let a = 5 in`
    , NoSimpleLetBody.rule

    -- Forbid unnecessary/overly verbose `case` blocks
    , NoSinglePatternCase.rule NoSinglePatternCase.fixInArgument

    -- Forbid use of type alias constructors except with Json.Decode.map
    , NoTypeAliasConstructorCall.rule

    -- Disallow matching `()` with `_`
    , NoUnmatchedUnit.rule

    -- Disallow inbound ports that do not use JSON (preventing run-time errors)
    , NoUnsafePorts.rule NoUnsafePorts.onlyIncomingPorts

    -- Forbid recursion without TCO
    , NoUnoptimizedRecursion.optOutWithComment "IGNORE TCO"
        |> NoUnoptimizedRecursion.rule

    -- Report unused custom type constructors
    , NoUnused.CustomTypeConstructors.rule []

    -- Report unused custom type fields
    , NoUnused.CustomTypeConstructorArgs.rule

    -- Report unused dependencies
    -- can't do this because we'll yank out elm/html, which lamdera needs under the covers
    --, NoUnused.Dependencies.rule
    -- Report exports never used in other modules
    , NoUnused.Exports.rule

    -- Report modules never used (or exported in the package)
    , NoUnused.Modules.rule

    -- Report unused function parameters
    , NoUnused.Parameters.rule

    -- Report unused parameters in pattern matching
    , NoUnused.Patterns.rule

    -- Report variables that are declared but never used
    , NoUnused.Variables.rule

    -- Ensure all ports are used
    , NoUnusedPorts.rule

    -- Reports `subscriptions` functions that never return a subscription.
    , NoUselessSubscriptions.rule

    -- Enforce pipeline style guidelines
    , List.concat
        [ -- |> should never have an input like `a |> b |> c` vs `b a |> c`
          -- <| should never have an unnecessary input like `a <| b <| c` vs `a <| b c`
          PremadePipelineRule.noPipelinesWithSimpleInputs

        -- Parenthetical application should never be nested more than once
        , PremadePipelineRule.noRepeatedParentheticalApplication

        -- Forbid use of non-commutative functions like `(++)`
        , PremadePipelineRule.noPipelinesWithConfusingNonCommutativeFunctions

        -- Forbid use of semantically "infix" functions like `Maybe.andThen` in left pipelines
        , PremadePipelineRule.noSemanticallyInfixFunctionsInLeftPipelines
        ]
        |> ReviewPipelineStyles.rule

    -- Detect simplifiable expressions, e.g. `a == True` can be simplified to `a`
    , Simplify.rule Simplify.defaults

    -- Enforce naming in camelCase and PascalCase
    , UseCamelCase.rule UseCamelCase.default
    ]
        |> List.map (Rule.ignoreErrorsForDirectories [ "src/Evergreen/" ])
