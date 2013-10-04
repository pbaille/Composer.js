define [
  "lib/core/base/Domain"
  "lib/utils/Combinatorics"
  "lib/core/composer/melody/MelodicPatternGen"
  "vendors/ruby"
  ], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  Domain = AC.Core.Domain
  Mode = AC.Core.Mode
  Pitch = AC.Core.Pitch
  DomainPartition = AC.Utils.DomainPartition #in combinatorics.coffee 
  MelodicPatternGen = AC.Core.MelodicPatternGen 
    
  class root.MGen extends Domain
    constructor: (opt) ->
      opt= {} unless opt #for being able to init without args
      
      #call Domain construct
      super
        mode: opt.mode || new Mode "C Lyd" # assign or default
        bounds: opt.bounds || [50,80] # assign or default

      @current_pitch = opt.current_pitch || @pitches[opt.current_index] || _a.pick_random_el @pitches
      @current_index = opt.current_index || @pitches.indexOf @current_pitch #index of @current_pitch in @pitches

      @melodicPatternGen = new MelodicPatternGen
        steps_array: [-3,-1,1,3]
        iterations: [1,2,3]
        cycle_step: [-3,-2,-1,1,2,3]
        pattern_length: [2,3,4] 

      if opt.strategy #define #next method in respect of given strategy
        @[opt.strategy.name](opt.strategy.args...) 
      else
        @step_pattern2()

        #step_pattern([3,3,-3],1,4) #default to some strat 
        # @interval_prob_array [
        #   {step: -3, occ: 3}
        #   {step: -1, occ: 1}
        #   {step: 3 , occ: 3}
        #   {step: 1 , occ: 1}
        # ] 

      

      @composer = null

    melodize: (positioned_rvals_arr) ->
      line = []
      for pos_rval in positioned_rvals_arr
        pitch = @next()
        vel = 60
        n = new AC.Core.Note(pitch.value, vel, pos_rval.rval, pos_rval.position)
        line.push(n)

      line

    set_current_pitch: (pitch) ->
      unless pitch instanceof Pitch
        pitch = new Pitch pitch

      pitches = @pitches.slice(0)
      pitches.sort (a,b) ->
        Math.abs(a.dist_to b)

      @current_pitch = pitches[0]
      @current_index = @pitches.indexOf @current_pitch  

    step: (n) ->
      new_index = @current_index + n
      if @pitches[new_index]
        @current_index = new_index
        @current_pitch = @pitches[new_index]
        return true
      else
        return false 

    bounds_from_current_pitch: ->
      [@current_index * -1, @pitches.length - @current_index - 1]     

    ########################
    ###### strategies ######
    ########################

    step_pattern: (step_sequence, cycle_step, iterations) -> 

      seq_total_step = _a.somme(step_sequence)
      step_sequence.push seq_total_step * -1 + cycle_step

      counter = -1
      done_count = step_sequence.length * iterations

      #temp: if domain bounds exceed invert pattern
      invert = ->
        step_sequence = step_sequence.map (x) -> x * -1

      @next = =>

        if @step step_sequence[0]
          counter++
          return @current_pitch if counter == 0 #play current_pitch at begining
          if counter < done_count 
            step_sequence = _a.rotate step_sequence,1
            @current_pitch
          else
            @strat_done() # pattern done, current_pitch setup for next strategy 
            @current_pitch # continue
        else
          invert() #here :)
          @next()

    step_pattern2: (melodicPattern) -> 
      unless melodicPattern
        melodicPattern = @melodicPatternGen.give_pattern(@bounds_from_current_pitch())

      @next = =>
        step = melodicPattern.next()
        if step
          if @step step
            @current_pitch

          else #if step out of bounds  
            @step_pattern2 @melodicPatternGen.give_pattern(@bounds_from_current_pitch())
            @next()
        else
          @step_pattern2 @melodicPatternGen.give_pattern(@bounds_from_current_pitch())
          @next() 

    drunk: (min,max,rep = false) ->
      @next = =>
        min++ while @current_index + min < 0 
        max-- while @current_index + max >= @pitches.length
  
        arr = [min..max]
        unless rep
          zero_index = arr.indexOf 0
          arr.splice(zero_index,1)
  
        s = _a.pick_random_el arr
        @step(s)
        @current_pitch

    interval_prob_array: (prob_array) ->

      @next = =>
        pioche = []
        for e in prob_array
          #e is a {step: int, occ: int} object
          if e.occ and @pitches[@current_index + e.step] 
            for x in [1..e.occ]
              pioche.push e.step
          #e is just an integer       
          else if @pitches[@current_index + e]
            pioche.push e 

        @step _a.pick_random_el(pioche) 
        @current_pitch   

    random_pitch: ->
      _a.pick_random_el @pitches

