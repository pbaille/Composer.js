define [], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Utils
  else
    root= window.AC.Utils 

  root.factorise = (numm) ->             # To calculate the prime factors of a number
    
    return [1] if numm is 1
    
    newnum = numm                        # Initialise
    result = []
    checker = 2                          # First possible factor to check
  
    while (checker*checker <= newnum)    # See if it is worth looking further for factors 
  
      if (newnum % checker == 0)         # If the possible factor is indeed a factor...
        result.push checker              # ...then record the factor
        newnum = newnum/checker          # and divide by it
      else                               # otherwise...
        checker++                        # try the next possible factor
  
    if (newnum != 1)                     # If there is anything left at the end...
      result.push newnum                 # so it too should be recorded
  
    return result                        # Return the prime factors
  
  return AC.Utils
#console.log factorise(242)

# Object.prototype.dup = () ->
#   JSON.parse(JSON.stringify(@))

# obj= 
#   a: 1
#   b: 2
#   display: () ->
#     console.log @

# R

# obj2 = obj.dup()

# obj2.display()

# obj.a = 3

# obj.display()
# obj2.display()