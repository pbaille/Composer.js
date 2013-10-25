define [], ->
  
  if typeof global != "undefined" && global != null 
    root= global.AC.Utils
  else
    root= window.AC.Utils

  root.gcd = (a, b) ->
    # Euclidean algorithm
    t = undefined
    until b is 0
      t = b
      b = a % b
      a = t
    a
    
  root.lcm = (a, b) ->
    a * b / root.gcd(a, b)
    
  root.lcmm = (arr) ->
    
    # Recursively iterate through pairs of arguments
    # i.e. lcm(args[0], lcm(args[1], lcm(args[2], args[3])))
    if arr.length is 2
      root.lcm arr[0], arr[1]
    else
      arr0 = arr.shift()
      root.lcm arr0, root.lcmm(arr)

  return root    