antlr         = require "antlr4"


first       = (arr) -> arr[0]
cons        = (x, arr) -> new Array x, arr...
bind_second = (fn, bound) -> (arg) -> fn arg, bound
extend      = (root, objs...) -> root[key] = value for key, value of obj for obj in objs
identity    = (obj) -> obj


first_rule = (parser) -> first parser.ruleNames

parser_rule_name = (tree) ->
  {name} = tree.constructor
  (name.replace "Context", "").toLowerCase()

# https://github.com/aphyr/clj-antlr/blob/03a817c1daf015364a0c769e212bc2d7a4418bbb/src/clj_antlr/coerce.clj#L22
sexpr = (tree, parser) ->
  if tree instanceof antlr.ParserRuleContext
    node = (cons (parser_rule_name tree),
                 tree.children.map (bind_second sexpr, parser))
  else
    tree.getText()


# https://github.com/aphyr/clj-antlr/blob/b38aad5fc441cb2f761b5baaa3d6fac2768d9bb6/src/clj_antlr/interpreted.clj#L79
#
# Re-uses the same lexer and parser each time. Note that the :tokens and
# :parser returned by (parse) may be mutated at any time; they should only be
# used for static things like resolving token names.
class Parser
  constructor: (@Lexer, @Parser, @opts) ->
    @opts or=
      format:          "sexp"
      root:            null
      ErrorListener:   require "./error-listener"

  parser: (opts, input) ->
    chars  = new antlr.InputStream input
    lexer  = new @Lexer chars
    if opts.ErrorListener
      lexer.removeErrorListeners()
      lexer.addErrorListeners new opts.ErrorListener

    tokens = new antlr.CommonTokenStream lexer
    parser = new @Parser tokens
    if opts.ErrorListener
      lexer.removeErrorListeners()
      lexer.addErrorListeners new opts.ErrorListener

    root   = opts.root or first_rule parser
    tree   = parser[root]()

  ###
  "Parses a string, reader, or inputstream using the given parser, and returns
  a data structure. If options are passed, override the options given at parser
  construction."
  ###
  parse: (opts, input) ->
    return @parse {}, opts unless input
    opts = extend {}, @opts, opts
    formatter = switch opts.format
      when "sexp" then sexpr
      when "raw"  then identity
      else sexpr

    formatter @parser opts, input


module.exports = Parser
