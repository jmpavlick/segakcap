# segakcap: elm reverse package search

[package.elm-lang.org](https://package.elm-lang.org) is great - but what if you aren't interested in finding a package, so much as finding packages that _depend on_ another package? For instance - what if you want to find every `elm-review` package? Currently, you have to hope that the word `"review"` is in the package name - but [this isn't](https://package.elm-lang.org/packages/canceraiddev/elm-pages/latest/) [always](https://package.elm-lang.org/packages/choonkeat/only-import-outside/latest/) [the case!](https://package.elm-lang.org/packages/lxierita/no-typealias-constructor-call/latest/).

Enter `segakcap`: a _reverse_ package search for Elm. By searching for `"elm-review"`, you can see all of the packages that _depend on_ it.

`segakcap` runs on [Lamdera](https://lamdera.com) and is hosted at https://segakcap.com.