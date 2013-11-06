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

      #Object (see default)
      @poly_prob = opt.prob || {bin: 1, ter: 0, quint: 0, sept: 0} #default to pure binary

      #RVal median val
      @median = opt.median || new RVal 1,2 #default to eight notes

      #[RVal,RVal] bound values
      @bounds = opt.bounds || [new RVal(2), new RVal(1,4)] # default to [half, sixteenth]

      #(float 0..1) median weight 
      @median_weight = opt.median_weight || 0.5

      #@rvals_prob_array = @rvals_prob_calc()
      @composed_rvals = @composed_rvals_calc(2)

    simple_rvals_calc: ->
      ret = {}
      for k,v of RK.simple_rvals
        ret[k] = _.filter v, (x) => x.le(@bounds[0]) and x.ge(@bounds[1])
      ret  

    simple_rvals_array: ->
      arr = _.values(@simple_rvals_calc())
      _.concat(arr...)

    composed_rvals_calc: (depth) ->
      ret = []
      for x in [2..depth]
        for comb in _.combinations(@simple_rvals_array(),x)
          sum = new RVal 0
          sum.add rv for rv in comb
          ret.push sum if sum.le(@bounds[0]) and sum.ge(@bounds[1])
      return ret      

      	

      



    

      