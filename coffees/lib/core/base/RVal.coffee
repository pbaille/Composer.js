define ["lib/utils/Rational","lib/utils/Utils", "vendors/ruby"], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  Rational = AC.Utils.Rational  
  Utils = AC.Utils

  class root.RVal extends Rational
  
    constructor: (num, den = 1) ->
      super(num, den)

    clone: ->
      new root.RVal @numer, @denom

    to_ms: (bpm) ->
      @times(new Rational(60,bpm)).toFloat() * 1000 

    polyrythmic_base: ->
      _a.last(Utils.factorise @denom)

    binary_base: ->
      pb= @polyrythmic_base() 
      if pb == 2 
        return new Rational(1,@denom) 
      else
        return new Rational(@numer,@denom / pb)

    multiplier: ->
      @numer

    #return array of allowed subs denominators (integers)
    allowed_subs: ->
      primes = Utils.factorise(@denom)
      results = [1] #prefill with 1 since every rval is allowed on beat
      for i in [1..primes.length]
        subset = _a.combination(primes,i)
        for e in subset
          results.push e.reduce (a,b) -> a * b

      return _a.uniq(results)  

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


