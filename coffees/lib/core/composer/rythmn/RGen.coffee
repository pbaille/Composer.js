define [
  "lib/core/base/RVal"
  "lib/core/base/Note"
  "lib/utils/Rational"
  "lib/utils/index"
  "lib/midi/play"
  "vendors/underscore"
  ], ->

  root= if global? then global.AC.Core else window.AC.Core  

  RVal = AC.Core.RVal
  Rational = AC.Utils.Rational    

  class root.RGen

    constructor: (opt) ->
      opt ?= {}
      @array = opt.prob_array || [] #array of {value: Rational_denom, occ: integer}

    set_prob_array: (rval_occ_objects_arr) ->
      @array = rval_occ_objects_arr

    build_prob_array: (opt) ->

      #rythmic base (2=> bin, 3=> ter etc...)
      base = opt.base || 2

      #Object (see default)
      poly_prob = opt.prob || {bin: 1, ter: 0, quint: 0, sept: 0} #default to pure binary

      #RVal median val
      median = opt.median || new RVal 1,2 #default to eight notes

      #[RVal,RVal] bound values
      bounds = opt.bounds || [new RVal(2), new RVal(1,4)] # default to [half, sixteenth]

      #(float 0..1) median weight 
      median_weight = opt.median_weight || 0.5

      #find_all_possible_rvals
      
      

      


         
    ############################ Should be private ########################

    generate: ->
      results = []

      while @composer.ahead.lt @composer.advance 
        results.push @next()

      return results

    generate2: (duration, n = 12) -> #(RVal)duration (int)n (number of notes wanted)
      rvcs = @rythmn_val_combinations(n,duration)
      rvc = _.sample rvcs
      console.log @rvals_allowed_permutations_at rvc, @composer.head_position()


    next: ->

      position = timeline.position.plus @composer.ahead

      #fill pioche in respect of each value occ
      pioche = []
      for x in @available_vals()
        for i in [0..x.occ-1]
          pioche.push x.rval

      #pick a random val in pioche and return it
      pioche = _.shuffle pioche
      @composer.ahead.add(pioche[0]) 

      return {position: position, rval: pioche[0]}

    available_vals: ->

      results = []
      for x in @array
        if x.occ != 0
          # push value in result if value + @head_position is on a available subdivision
          cond1 = x.rval.allowed_subs().indexOf(x.rval.plus(timeline.position.sub.plus(@composer.ahead)).denom) >= 0
          results.push x if cond1

      # head unable to resolve on an available subdivision, 
      # have to resolve it with non available value
      if results.length == 0
        results.push @resolve_head()

      return results

    #called if no rythmn values available, 
    #it compute a value to resolve the head position on availables subdivisions
    resolve_head: ->

      throw " have to implement Rgen#resolve_head "

    # compute all ([RVal or Rational])rat_arr combination of "size" size that sums to (RVal or Rational)sum 
    rat_dom_part: (rat_arr,size,sum) ->

      # all denoms array
      denoms = rat_arr.concat(sum).map (x) ->
        x.denom
      # find least common multiplier for domain elems and sum
      lcm = AC.Utils.lcmm denoms 
      # multiply all domain elems by it and cast to int 
      dom = rat_arr.map (x)->
        x.multiply new RVal lcm
        x.toInt()
      # sort new dom
      dom = _.sort dom  
      # compute new sum (sum * lcm)
      msum = sum.multiply(new RVal(lcm)).toInt()

      # regular call to DomainPartition since all elems are now integers
      dp = new AC.Utils.DomainPartition dom,size,msum

      results = []
      #remap integers to rationals and append them to results array
      for res in dp.results
        results.push res.map (x) -> new RVal x,lcm

      return results 

    # call rat_dom_part with @array.rval(s)
    rythmn_val_combinations: (size, sum) -> # (int)size (RVal)sum
      #console.log @array
      rvals = @array.map (x) ->
        x.rval
      return @rat_dom_part(rvals,size,sum)

    rvals_allowed_permutations_at: (rvals, start_position) -> #(array of RVal(s))rvals (Position)start_position
      
      # helpers
      uniq_rvals_calc = ->
        result= []
        for rv in rvals
          if result.length is 0
            result.push rv
          else  
            already_in = false
            for urv in result
              already_in = true if rv.eq urv
            result.push rv unless already_in
        return result

      remaining_rvals= (rvals_array) ->
        #debugger
        result = rvals.slice 0
        for rv in rvals_array
          for x,i in result
            if x.eq rv
              result.splice(i,1) 
              break
        return result    

      #uniq rvals
      uniq_rvals = uniq_rvals_calc()
      
      results = []   
      for i in [1..rvals.length]
        #debugger
        if i is 1
          for rv in uniq_rvals
            results.push [rv] if rv.is_allowed_at start_position
        else
          temp = []
          for rv in uniq_rvals
            for r in results
              # compute current_position
              current_position = start_position.clone()
              current_position = current_position.plus(rv2) for rv2 in r

              # check if rv is available in remaining_rvals
              rv_is_available = false
              for rem_val in remaining_rvals r
                if rv.eq rem_val
                  rv_is_available = true 
                  break
              # if on an available subdivision and stil available push it  
              if rv.is_allowed_at(current_position) and rv_is_available
                temp.push r.concat(rv) 

          results = temp  

      return results    
              


          







