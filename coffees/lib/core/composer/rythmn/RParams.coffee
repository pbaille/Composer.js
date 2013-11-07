define [
  "lib/core/base/RVal"
  "lib/core/base/Note"
  "lib/core/composer/rythmn/RConstants"
  "lib/utils/index"
  "vendors/underscore"
  "lib/utils/underscore_adds"
  ], ->

  root= if global? then global.AC.Core else window.AC.Core  

  RK = root.RK
  RVal = AC.Core.RVal
  Rational = AC.Utils.Rational    

  class root.RParams

    constructor: (opt) ->

      #rythmic base (2=> bin, 3=> ter etc...)
      @base = opt.base || 2

      #default values
      @prob = 
        poly_roots: {bin: 1, ter: 0, quint: 0, sept: 0} #default to pure binary
        compositions: {simple: 1, double: 0.5, triple: 0}
        poly_depths: {one: 1, two: 0 , three: 0}
      
      #override defaults if user give opt.prob
      @prob[k] = v for k,v of opt.prob

      #RVal median val
      @median = opt.median || new RVal 1,2 #default to eight notes
      #(float 0..1) median weight 
      @median_weight = opt.median_weight || 0.5

      #[RVal,RVal] bound values
      @bounds = opt.bounds || [new RVal(2), new RVal(1,4)] # default to [half, sixteenth]

      #@rvals_prob_array = @rvals_prob_calc()
      @simple_rvals = @simple_rvals_calc()
      @composed_rvals = @composed_rvals_calc()

    simple_rvals_calc: ->
      ret = {}
      for k,v of RK.simple_rvals
        ret[k] = _.filter v, (x) => x.le(@bounds[0]) and x.ge(@bounds[1])
      ret  

    simple_rvals_array: ->
      arr = _.values @simple_rvals_calc()
      _.concat(arr...)

    composed_rvals_calc: () ->

      depths = []
      for x,i of _.values @prob.compositions
        depth.push i if x isnt 0

      ret = []
      for x in depths
        for comb in _.combinations(@simple_rvals_array(),x)
          sum = new RVal 0
          sum.add rv for rv in comb
          ret.push sum if sum.le(@bounds[0]) and sum.ge(@bounds[1])
      return ret      
    

      	

      



    

      