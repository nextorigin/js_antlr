{ErrorListener} = require "antlr4/error/ErrorListener"


# https://blog.logentries.com/2015/06/how-to-implement-antlr4-autocomplete/
class JSErrorListener extends ErrorListener
  syntaxError: (recognizer, offendingSymbol, line, column, msg, e) ->
    super


module.exports = JSErrorListener
