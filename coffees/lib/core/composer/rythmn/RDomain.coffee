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

  class root.RDomain

    constructor: (opt) ->

      #default values
      @prob = 
        poly_roots: {bin: 1, ter: 0.5, quint: 0, sept: 0} #default to pure binary
        compositions: {simple: 1, double: 0.5, triple: 0}
        #TODO poly_depths: {'1': 1, '2': 0 , '3': 0}
      
      #override defaults if user give opt.prob
      @prob[k] = v for k,v of opt.prob

      #RVal median val
      @median = opt.median || new RVal 1,2 #default to eight notes
      #(int) median weight (median prob will be $int times greater than bounds prob)
      @median_weight = opt.median_weight || 10

      #[RVal,RVal] bound values
      @bounds = opt.bounds || [new RVal(2), new RVal(1,4)] # default to [half, sixteenth]

      @rvals = {}
      @_rvals_calc()

      @pool = @_make_pool()

    peek_one: -> @pool.peek()[0]
    
    #takes n uniq elems from pool
    peek_uniqs: (n, removeBool) -> @pool.peek(n,removeBool)  
    
    # takes n elems from pool (may be duplicates)
    peek: (n) -> (@peek_one() for i in [1..n])
    
    # take n uniqs elems from pool and delete them from it
    pop: (n) -> @pool.pop(n)  

  ############ setters #################    

    set_median: (rval) -> 
      @median = rval 
      @_rvals_calc()
      this
    set_median_weight: (int) -> 
      @median_weight = int 
      @_rvals_calc()
      this
    set_bounds: (slowest,highest) -> 
      @bounds = [slowest,highest] 
      @_rvals_calc()
      this
    set_prob: (obj) ->
      return false unless obj 
      @prob.poly_roots[k] = v for k,v of obj.poly_roots 
      @prob.compositions[k] = v for k,v of obj.compositions
      @_rvals_calc() 
      this
    set: (obj) ->
      @median = opt.median if opt.median
      @median_weight = opt.median_weight if opt.median_weight
      @bounds = opt.bounds if opt.bounds
      if obj.prob then @set_prob(obj.prob) else @_rvals_calc()
      this

  
  ############# private ###############

    _make_pool: ->
      rvals = _.concat(@rvals.simple,@rvals.composed)
      data = _.map rvals, (x) ->
        [x.toString(),_.product(_.values(x.prob)),x]
      _.weightedList(data)
    
    _rvals_calc: ->
      @rvals.simple= @_simple_rvals_calc()
      @rvals.composed= @_composed_rvals_calc()

    _simple_rvals_calc: ->
      ret = []
      for k,v of RK.simple_rvals
        unless @prob.poly_roots[k] is 0
          #remove out of bounds rvals
          rvals = _.filter v, (rval) => @_in_bounds(rval)
          for el in rvals
            #extend RVal with a prob property
            el.prob = 
              poly: @prob.poly_roots[k]
              composition: @prob.compositions.simple
              distance: @_distance_prob(el)

            ret.push el 

      return ret   

    _composed_rvals_calc: () ->
      ret = []
      for k,v of @prob.compositions
        if v isnt 0 and k isnt "simple"
          n = if k is "double" then 2 else 3
          #group rvals by polyrythmic base
          poly_base_based_group = _.groupBy @rvals.simple, (x) -> x.polyrythmic_base()

          for poly_group in _.values poly_base_based_group
            for comb in _.combinations(poly_group,n)
              # init val
              val = new RVal 0
              
              #compute val by adding comb elems together
              val.add rv for rv in comb

              #check if value is not a simple rval
              isnt_a_simple_rval = val.polyrythmic_base() is comb[0].polyrythmic_base()
              #push it into result array
              ret.push val if @_in_bounds(val) and isnt_a_simple_rval

              #compute prob
              prob = 
                poly: _.median(_.map comb, (el) -> el.prob.poly)
                composition: @prob.compositions[k] 
                distance: @_distance_prob(val)

              #extend RVal with prob property
              val.prob = prob

      return ret   
    
    _distance_prob: (rval) ->
      if rval.lt @median
        return _.scale(@median.minus(rval).toFloat(),
                       @median.minus(@bounds[1]).toFloat(),0,1,@median_weight)

      else if rval.gt @median  
        return _.scale(rval.minus(@median).toFloat(),
                       @bounds[0].minus(@median).toFloat(),0,1,@median_weight)
      else 
        return @median_weight 

    _in_bounds: (rval) ->
      rval.le(@bounds[0]) and rval.ge(@bounds[1])     
        
        

        

    

      	

      



    

      