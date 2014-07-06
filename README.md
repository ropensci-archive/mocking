mocking
======

This is a simple R package to demonstrate the use of `mocker`, a single interface to many backends for caching web calls.

This package has a single function `searchGBIF()`, that allows a simple taxonomic name based search of [GBIF](http://www.gbif.org/) data.

`mocking` demonstrates how a package could use `mocker` as a utility to allow users to optionally cache data from web API calls to many different backends, including:

* `.rds` files, via `saveRDS`
* Compressed `.gz` files, via the `R.cache` package
* `redis`
* `SQLite`
* `CouchDB`

`mocker` is set up to support two approaches:

1. Pass in arguments via your functions to change caching, or
2. Set options via `options`, then `mocker` reads these. This makes your function calls cleaner by avoiding the extra parameter settings. If you use options, arguments passed in to the function call will override options settings. This approach isn't working yet, but soon...

The advantages of using `mocker` are:

* A single interface to many different caching options
* knitr's `cache=TRUE` is great, but sometimes you aren't working in a  knitr document
* Whether you have an internet connection or not, you can still sling code (as long as you have cached calls before your Wifi turned off)
