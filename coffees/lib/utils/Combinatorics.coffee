define ["vendors/ruby"], ->
  
  if typeof global != "undefined" && global != null 
    root= global.AC.Utils
  else
    root= window.AC.Utils	

  class root.DomainPartition
    
    constructor: (_dom, _size, _sum) ->
      @domain=_a.sort(_dom)
      @results = []
      @sum = _sum
      @size = _size

      arr = []
      arr.push(0) for [1.._size] # create an array of size n, filled with zeroes

      @sumRecursive(@size, 0, arr)
        
    sumRecursive: (n, sumSoFar, arr) ->
      #debugger	
      if n == 1
        #Make sure it's in ascending order (or only level)
        if @sum - sumSoFar >= arr[arr.length - 2] and @domain.indexOf(@sum - sumSoFar) >= 0
          final_arr= arr.slice 0
          final_arr[final_arr.length-1] = @sum - sumSoFar #put it in the n_th last index of arr
          @results.push final_arr
            
      else if n > 1
    
        #********* dom_selector ********
        #is an previously rejected domain element can be authorized?...
    
        if n != @size then start = arr[arr.length - n - 1] else start = @domain[0]
        dom_bounds= [start*(n-1),@domain[@domain.length - 1]*(n-1)]
        
        restricted_dom= []
        for x in @domain

          if x < start 
          	"nothing"
          
          else if @size-n > 0
            temp = @sum - (_a.somme(arr[0..arr.length - n - 1]) + x)
            if dom_bounds[0] <= temp and dom_bounds[1] >= temp
              restricted_dom.push x
            
          else if dom_bounds[0] <= @sum+x and dom_bounds[1] >= @sum+x
            restricted_dom.push x
            
        for i in restricted_dom
          _arr= arr.slice 0
          _arr[_arr.length - n] = i 
          @sumRecursive(n-1, sumSoFar + i, _arr)

          
