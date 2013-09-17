#little hack to test stuff in terminal with node

# requirejs = require('requirejs')

# requirejs.config
#     nodeRequire: require


# requirejs ['./utils/Rational', './utils/Utils', '../vendors/ruby'], (Rational, Utils, RubyJs) ->

###############################################
define ["lib/utils/Rational","lib/utils/Utils", "vendors/ruby"], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  class root.RVal extends AC.Utils.Rational
  
    constructor: (num, den) ->
      super(num, den)

    to_ms: (bpm) ->
      @times(new AC.Utils.Rational(60,bpm)).toFloat() * 1000 

    polyrythmic_base: ->
      _a.last(AC.Utils.factorise @denom)

    binary_base: ->
      pb= @polyrythmic_base() 
      if pb == 2 
        return pb 
      else
        @denom / pb




  
  # a = new AC.Core.RVal(1,20)
  # console.log a.toString()
  # console.log a.to_ms(120)
  # console.log a.polyrythmic_base()


