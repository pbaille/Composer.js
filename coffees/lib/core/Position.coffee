define ["lib/core/RVal"], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  RVal = AC.Core.RVal

  class root.Position

    constructor: (opt) ->
      opt = {} unless opt
      @cycle= opt.cycle || 0
      @bar= opt.bar || 0
      @sub= opt.sub || new RVal 0
      @timeline = opt.timeline || null

    cycle_ms_duration: ->
      result = 0
      for b in @timeline.grid  
      	result+= b.ms_duration()
      return result

    previous_cycles_duration: ->
      @cycle_ms_duration() * @cycle

    previous_bars_duration: ->
      result = 0
      return 0 if @bar == 0 
      
      for i in [0..@bar-1]
        result+= @timeline.grid[i].ms_duration()

      return result 

    total_time: ->  
      @previous_cycles_duration() + @previous_bars_duration() + @timeline.grid[@bar].ms_duration_at(@sub)  
      
    # doesn't modify caller
    plus: (rval) ->

      clone = @clone() # at start

      addition = clone.sub.plus rval
      diff = addition.minus clone.timeline.grid[clone.bar].duration()

      # if no need to increment bar
      if diff.isNegative()
        clone.sub = addition
        return clone 
      else 
        # if last bar of timeline.grid
        clone.sub = new RVal 0
        if clone.bar == clone.timeline.grid.length - 1
          clone.cycle++
          clone.bar = 0
        else  
          clone.bar++
        
        #recursion !!!!
        clone.plus diff

      
    # almost a duplicate of #plus ... 
    # return ms time of a rythmic value at this position (@)
    rval_to_ms: (rval,_result) ->

      clone = @clone() # at start

      # clever explanation
      if _result is undefined
        _result = clone.timeline.grid[clone.bar].ms_duration_at(clone.sub) * -1

      addition = clone.sub.plus rval
      diff = addition.minus clone.timeline.grid[clone.bar].duration()

      # if no need to increment bar
      if diff.isNegative() #le new RVal 0
        clone.sub = addition
        return _result + clone.timeline.grid[clone.bar].ms_duration_at(clone.sub) 
      else 
        temp = _result + clone.timeline.grid[clone.bar].ms_duration()
        return temp if diff.isZero()

        _result += clone.timeline.grid[clone.bar].ms_duration()
        clone.sub = new RVal 0
        if clone.bar == clone.timeline.grid.length - 1
          clone.cycle++
          clone.bar = 0
        else  
          clone.bar++
        
        #recursion !!!!
        clone.rval_to_ms diff, _result
 

    # compute the duration in ms of a positioned rythmic value (RVal)
    # positioned_rval => {position: 'position object', rval: RVal object}
    positioned_rval_to_ms: (positioned_rval) ->  

      "TODO !!!!!!!!"

    to_performance_time: () ->
      @timeline.origin_point + @total_time()

    clone: ->
      new root.Position
        cycle: @cycle
        bar: @bar
        sub: @sub 
        timeline: @timeline  

    toString: ->
      "#cycle: #{@cycle} // bar: #{@bar} // sub: #{@sub.numer + '/' + @sub.denom}"     

    # distance: (position) ->
      	