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

  RK.bases_map = {bin: 2, ter: 3, quint: 5, sept: 7}
  RK.bases = _.values RK.bases_map
  RK.bases_names = _.keys RK.bases_map


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

  #########  
  return RK  
