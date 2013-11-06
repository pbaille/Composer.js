define [
  "lib/core/base/RVal"
  "lib/core/base/Note"
  "lib/utils/index"
  "vendors/underscore"
  "lib/utils/underscore_adds"
  ], ->

  root= if global? then global.AC.Core else window.AC.Core  

  RVal = AC.Core.RVal
  Rational = AC.Utils.Rational 

  RK = root.RK = {}

  RK.bases = [2,3,5,7]
  RK.bases_names = ["bin", "ter", "quint", "sept"]

  RK.bounds = [new RVal(4),new RVal(1,16)] #from whole to "quadruple croche"

  RK.simple_rvals = do ->
  	ret = {bin: [RK.bounds[0]], ter:[], quint:[], sept:[]}
  	for base,i in RK.bases	
      current_val = RK.bounds[0].div new RVal base
      current_val.divide new RVal 2 while current_val.gt RK.bounds[0]
      while current_val.ge RK.bounds[1]
        ret[RK.bases_names[i]].push current_val.clone()
        current_val.divide new RVal 2
    return ret
  
  #return rvals like 3/2, 7/4 , 5/6 etc (simple_rvals mult by nonself bases) 
  RK.composite_rvals = do ->
    ret = {bin:[], ter:[], quint:[], sept:[]}
    for base_name,rvals of RK.simple_rvals
      base_index = _.indexOf RK.bases_names,base_name
      base = RK.bases[base_index]
      for rv in rvals
        for b in RK.bases[1..] #remove base 2
          temp = rv.clone().times new RVal(b)
          unless b == base or temp.ge RK.bounds[0]
            ret[base_name].push temp 
    return ret  	  	
  
  RK.poly_rvals = "TODO"

  RK.all_rvals = do ->
  	ret = {}
  	simple = RK.simple_rvals
  	composite = RK.composite_rvals
  	for k in RK.bases_names
      ret[k] = _.concat simple[k], composite[k]
    return ret  

  #########  
  return RK  
