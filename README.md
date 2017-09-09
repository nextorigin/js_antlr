# js_antlr

[![Greenkeeper badge](https://badges.greenkeeper.io/nextorigin/js_antlr.svg)](https://greenkeeper.io/)

Partial port of [aphyr/clj-antlr][clj-antlr] bindings for ANTLR 4 parser library, returning a tree or sexpr-formatted tree

## Installation
```sh
npm install --save js_antlr
```

## Usage

Compile your Grammar to a [JS lexer and parser](https://github.com/antlr/antlr4/blob/master/doc/javascript-target.md#how-to-create-a-javascript-lexer-or-parser).
```coffee
{YourLexer}  = require "./YourLexer"
{YourParser} = require "./YourParser"

options =
  format: "sexp"
  root:   null

parser = new Parser YourLexer, YourParser, options

string        = "someNum > 3"
sexpParseTree = parser.parse string
```

## License

EPL-1.0 adopted from [clj-antlr][clj-antlr]

  [clj-antlr]: https://github.com/aphyr/clj-antlr
