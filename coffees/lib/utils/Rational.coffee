define [], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Utils
  else
    root= window.AC.Utils

  # RVal = AC.Core.RVal  

  # the constructor
  class root.Rational
    constructor : (numerator, denominator) ->
      if denominator is `undefined`
        denominator = 1
      else throw "divide by zero"  if denominator is 0
      @numer = numerator
      if @numer is 0
        @denom = 1
      else
        @denom = denominator
      @normalize()
    
    # getter methods
    numerator : ->
      @numer
    
    denominator : ->
      @denom
    
    # clone a rational
    dup : ->
      new AC.Utils.Rational(@numerator(), @denominator())
    
    
    # conversion methods
    toString : ->
      if @denominator() is 1
        @numerator().toString()
      else
        
        # implicit conversion of numbers to strings
        @numerator() + "/" + @denominator()
    
    toFloat : ->
      @numer / @denom
    
    toInt : ->
      Math.floor @toFloat()

    toRVal: ->
      new AC.Core.RVal @numer, @denom  
    
    # reduce 
    normalize : ->
      
      # greatest common divisor
      a = Math.abs(@numerator())
      b = Math.abs(@denominator())
      until b is 0
        tmp = a
        a = b
        b = tmp % b
      
      # a is the gcd
      @numer /= a
      @denom /= a
      if @denom < 0
        @numer *= -1
        @denom *= -1
      this
    
    
    # absolute value
    # returns a new rational
    abs : ->
      new AC.Utils.Rational(Math.abs(@numerator()), @denominator())
    
    
    # inverse
    # returns a new rational
    inv : ->
      new AC.Utils.Rational(@denominator(), @numerator())
    
    
    #
    # arithmetic methods
    
    # variadic, modifies receiver
    add : (rat)->
      @numer = @numer * rat.denom + @denom * rat.numer
      @denom = @denom * rat.denom
      @normalize()

    plus : (rat)->
      rat = new AC.Utils.Rational(rat,1) unless rat.numer #convert integer to rational
      n = @numer * rat.denom + @denom * rat.numer
      d = @denom * rat.denom
      result = new AC.Utils.Rational(n,d)
      result.normalize()  
      result   

    minus : (rat)->
      rat = new AC.Utils.Rational(rat,1) unless rat.numer #convert integer to rational
      n = @numer * rat.denom - @denom * rat.numer
      d = @denom * rat.denom
      result = new AC.Utils.Rational(n,d)
      result.normalize()  
      result  
    
    # variadic, modifies receiver
    subtract : ->
      i = 0
    
      while i < arguments.length

        if typeof arguments[i] == 'number'
          rat = new AC.Utils.Rational(arguments[i],1)
        else 
          rat = arguments[i]

        @numer = @numer * rat.denominator() - @denom * rat.numerator()
        @denom = @denom * rat.denominator()
        i++
      @normalize()
    
    
    # unary "-" operator
    # returns a new rational
    neg : ->
      (new AC.Utils.Rational(0)).subtract this
    
    times : (rat)->
      rat = new AC.Utils.Rational(rat,1) unless rat.numer #convert integer to rational
      n = @numer * rat.numer
      d = @denom * rat.denom
      new AC.Utils.Rational(n,d) 

    # variadic, modifies receiver
    multiply : ->
      i = 0
    
      while i < arguments.length
        @numer *= arguments[i].numerator()
        @denom *= arguments[i].denominator()
        i++
      @normalize()
    
    
    # modifies receiver
    divide : (rat) ->
      @multiply rat.inv()

    div : (rat) ->
      @times rat.inv()  
    
    
    # increment
    # modifies receiver
    inc : ->
      @numer += @denominator()
      @normalize()
    
    
    # decrement
    # modifies receiver
    dec : ->
      @numer -= @denominator()
      @normalize()
    
    
    #
    # comparison methods
    isZero : ->
      @numerator() is 0
    
    isPositive : ->
      @numerator() > 0
    
    isNegative : ->
      @numerator() < 0
    
    eq : (rat) ->
      self = @dup().normalize()
      self.numer == rat.numer and self.denom == rat.denom
    
    ne : (rat) ->
      not (@eq(rat))
    
    lt : (rat) ->
      @dup().subtract(rat).isNegative()
    
    gt : (rat) ->
      @dup().subtract(rat).isPositive()
    
    le : (rat) ->
      not (@gt(rat))
    
    ge : (rat) ->
      not (@lt(rat))