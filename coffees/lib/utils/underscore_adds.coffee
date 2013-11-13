define ["vendors/underscore","vendors/weightedList"], ->

  _.mixin
  
  ############# Numerics ###############################
  
    gcd: (a, b) ->
      # Euclidean algorithm
      t = undefined
      until b is 0
        t = b
        b = a % b
        a = t
      a
        
    lcm: (a, b) -> 
    	a * b / _.gcd(a, b)
      
    lcmm: (arr) ->
      # Recursively iterate through pairs of arguments
      # i.e. lcm(args[0], lcm(args[1], lcm(args[2], args[3])))
      if arr.length is 2
        _.lcm arr[0], arr[1]
      else
        arr0 = arr.shift()
        _.lcm arr0, _.lcmm(arr)

    sum: (arr)->
      _.reduce arr, (acc, el) -> acc+= el
    
    # can be passed either array of Numbers or several Numbers
    product: (args...) ->
      args = args[0] if _.isArray args[0]
      _.reduce args, (a,b) ->
        a*b
      , 1     

    factorise: (numm) ->             # To calculate the prime factors of a number
    
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
      
  ############## generic ##############################
    
    sort: (arr) ->
      arr.sort(10)

    concat: (args...) ->
      _.reduce args, (acc,el,coll) -> acc.concat el,[]
  
    wrap_if_not: (arr) ->
      arr = [arr] unless arr instanceof Array 
      return arr
  
    reverse: (coll) ->
      _.reduceRight coll, (acc,x) ->
        acc.concat x
      ,[]  
    
    rotate: (coll, step) ->
      step += coll.length while step < 0
      tail = coll.slice(0,step)
      head = coll.slice(step)
      head.concat tail
  
    rotations: (arr) ->
      _.map arr, (el,index) ->
        _.rotate(arr,index)
  
    uniqRotations: (arr) ->
      _.compose(_.uniq, _.rotations)(arr)
  
    median: (args...) ->
      args = args[0] if _.isArray args[0]
      _.sum(args)/args.length
  
    
    # underscore's uniq works only on [primitives]
    deepUniq: (coll) ->
      result = []
      recursive_pick_and_clean = (coll2) ->
        
        rest = _.rest(coll2)
        first = _.first(coll2)
        result.push first
        equalsFirst = (el) -> _.isEqual(el,first)
  
        newColl = _.reject rest, equalsFirst
  
        unless _.isEmpty newColl
          recursive_pick_and_clean newColl
      
      recursive_pick_and_clean coll
      result  

    scale: (numArray, inMin, inMax, outMin, outMax) ->
      
      if arguments.length is 5
        # Figure out how 'wide' each range is
        inSpan = inMax - inMin
        outSpan = outMax - outMin

        map_fun = (elem) ->
          # Convert the left range into a 0-1 range (float)
          valueScaled = (elem - inMin) / inSpan
          # Convert the 0-1 range into a value in the out range.
          outMin + (valueScaled * outSpan)
        
        if _.isArray(numArray) then return _.map numArray, map_fun
        else return map_fun(numArray)
            
      # return a curry4 function that takes only an array    
      else if arguments.length is 4
        args = _.toArray arguments
        return (arr) ->
          _.scale(arr,args[0], args[1], args[2], args[3])

  
  ################# music purpose ############################# 
  
    tonicize: (arr) ->
      _(arr).map (x,i,c) ->
        (x - c[0] + 12 ) % 12
      .sort()  
  
    tonicized_rotations:(arr) ->
      _.map _.rotations(arr), _.tonicize
  
    to_functs:(arr) ->
      _.map arr,(i) -> if i then i % 12 else i  
    
  #################### Combinatorics #########################

    combinations: (arr, p) ->

      return [ [] ] if p == 0
      i = 0
      n = arr.length
      combos = []
      combo = []
      while combo.length < p
        if i < n
          combo.push i
          i += 1
        else
          break if combo.length == 0
          i = combo.pop() + 1
     
        if combo.length == p
          combos.push _.clone(combo)
          i = combo.pop() + 1

      _.map combos, (x) ->
        _.map x, (index) -> arr[index]

    unique_permutation: (coll) ->
  
      array_copy = coll.sort(10)
      results = []
      results.push _.clone(array_copy)
      size = _.size(coll)
      return if size < 2
  
      while true
        # Based off of Algorithm L (Donald Knuth)
        j = _.size(coll) - 2
        j -= 1 while j > 0 and array_copy[j] >= array_copy[j+1]
  
        if array_copy[j] < array_copy[j+1]
  
          l = size - 1
          l -= 1 while array_copy[j] >= array_copy[l]
  
          [array_copy[j],array_copy[l]]=[array_copy[l],array_copy[j]]
  
          rev = _.reverse(array_copy)
          range = [j+1..size-1]
  
          array_copy[e]=rev[i] for e, i in range
          results.push _.clone(array_copy)
  
        else break
  
      return results  
  
    #a=int[] (maxVal of each slot)
    # Caution!!! values from 0! 1=> 2 status (0,1)
    statusCombination: (arr) ->
      init = []
      init.push [x] for x in [0..arr[0]]	
      _.reduce _.rest(arr), (final,el,index) ->
        clone = _.clone final
        final = [] 
        for e in clone
          final.push e.concat x for x in [0..el]
        return final
      ,init
  
    
    comb_zip: (a) ->
      status_tab= a.map (x) -> x.length-1
      _.reduce _.statusCombination(status_tab)
        ,(final,el,index) ->
        	final.push _.map el, (x,i) -> a[i][x]
        	return final
        ,[]
  
    domainPartition: (dom, size, sum) ->
      domain= dom.sort(10)
      results = []
      arr = _.map [1..size], -> 0 # create an array of size n, filled with zeroes
          
      sumRecursive= (n, sumSoFar, arr) ->
        #debugger	
        if n == 1
          #Make sure it's in ascending order (or only level)
          if sum - sumSoFar >= arr[arr.length - 2] and domain.indexOf(sum - sumSoFar) >= 0
            final_arr= arr.slice 0
            final_arr[final_arr.length-1] = sum - sumSoFar #put it in the n_th last index of arr
            results.push final_arr
              
        else if n > 1
      
          if n != size then start = arr[arr.length - n - 1] else start = domain[0]
          dom_bounds= [start*(n-1),domain[domain.length - 1]*(n-1)]
          
          restricted_dom= []
          for x in domain
            unless x < start 
              if dom_bounds[0]+x <= sum - sumSoFar <= dom_bounds[1]+x
                restricted_dom.push x
              
          for i in restricted_dom
            _arr= arr.slice 0
            _arr[_arr.length - n] = i 
            sumRecursive(n-1, sumSoFar + i, _arr)
  
      sumRecursive(size, 0, arr) 
      return results     

  ############################# PROB ##############################

    weightedList: (args...) ->
      if args[1] then args = _.concat(args) else args = args[0]
      return new WeightedList args



# console.log _.rotations([1,2,3]) 
# console.log _.uniqRotations([1,2,1,2])
# console.log _.tonicized_rotations [3,6,9,1]
# console.log _.to_functs [1,23,67]
# console.log _.deepUniq([ {a:1,b:12}, [ 2, 1, 2, 1 ], [ 1, 2, 1, 2 ], {a:1,b:12} ]) 
# console.log _.unique_permutation [1,1,2,3]
# console.log _.reverse [1,2,3]
# console.log _.comb_zip [[1,2],[3,5,6]]
# console.log _.statusCombination [2,2,2]
# console.log _.domainPartition [-2,-1,1,2,3],4,5
# console.log _.lcmm [5,8,2,6,7]
