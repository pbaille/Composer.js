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

  Rational = AC.Utils.Rational  

  class root.RVal extends Rational
  
    constructor: (num, den = 1) ->
      super(num, den)

    to_ms: (bpm) ->
      @times(new Rational(60,bpm)).toFloat() * 1000 

    polyrythmic_base: ->
      _a.last(AC.Utils.factorise @denom)

    binary_base: ->
      pb= @polyrythmic_base() 
      if pb == 2 
        return new Rational(1,@denom) 
      else
        return new Rational(@numer,@denom / pb)

    multiplier: ->
      @numer

    show_bases: ->
      console.log "poly: " + @polyrythmic_base() + " \nbinary: " + @binary_base() + " \nmultiplier: " + @multiplier()

    # method from Rational
    times: (rat)->
      super(rat).toRVal()

    div: (rat) ->
      super(rat).toRVal()  

    plus: (rat)->
      super(rat).toRVal() 

    minus: (rat)->
      super(rat).toRVal()  





  
  # a = new AC.Core.RVal(1,20)
  # console.log a.toString()
  # console.log a.to_ms(120)
  # console.log a.polyrythmic_base()


