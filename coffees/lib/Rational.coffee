define [], () ->
  # the constructor
  class Rational
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
      new Rational(@numerator(), @denominator())
    
    
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
      new Rational(Math.abs(@numerator()), @denominator())
    
    
    # inverse
    # returns a new rational
    inv : ->
      new Rational(@denominator(), @numerator())
    
    
    #
    # arithmetic methods
    
    # variadic, modifies receiver
    add : (rat)->
      @numer = @numer * rat.denom + @denom * rat.numer
      @denom = @denom * rat.denom
      @normalize()

    plus : (rat)->
      n = @numer * rat.denom + @denom * rat.numer
      d = @denom * rat.denom
      result = new Rational(n,d)
      result.normalize()  
      result   

    minus : (rat)->
      n = @numer * rat.denom - @denom * rat.numer
      d = @denom * rat.denom
      result = new Rational(n,d)
      result.normalize()  
      result  
    
    # variadic, modifies receiver
    subtract : ->
      i = 0
    
      while i < arguments_.length
        @numer = @numer * arguments_[i].denominator() - @denom * arguments_[i].numerator()
        @denom = @denom * arguments_[i].denominator()
        i++
      @normalize()
    
    
    # unary "-" operator
    # returns a new rational
    neg : ->
      (new Rational(0)).subtract this
    
    
    # variadic, modifies receiver
    multiply : ->
      i = 0
    
      while i < arguments_.length
        @numer *= arguments_[i].numerator()
        @denom *= arguments_[i].denominator()
        i++
      @normalize()
    
    
    # modifies receiver
    divide : (rat) ->
      @multiply rat.inv()
    
    
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