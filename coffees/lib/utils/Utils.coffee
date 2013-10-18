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
  

  root.clone = (obj) ->
    if not obj? or typeof obj isnt 'object'
      return obj
  
    if obj instanceof Date
      return new Date(obj.getTime()) 
  
    if obj instanceof RegExp
      flags = ''
      flags += 'g' if obj.global?
      flags += 'i' if obj.ignoreCase?
      flags += 'm' if obj.multiline?
      flags += 'y' if obj.sticky?
      return new RegExp(obj.source, flags) 
  
    newInstance = new obj.constructor()
  
    for key of obj
      newInstance[key] = clone obj[key]
  
    return newInstance

  root.merge = (objects...)->
    res = {}
    for o in objects
      for k,v of o
        res[k]= v
    return res

  return AC.Utils
  


