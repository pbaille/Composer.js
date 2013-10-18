define [
  "lib/core/base/Domain"
  "lib/utils/Combinatorics"
  "lib/utils/Module"
  "lib/core/composer/melody/MelodicPatternGen"
  "lib/core/composer/melody/PassingTones"
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
  PassingTones = AC.Core.PassingTones
  Module = AC.Utils.Module

    
  class root.MGen extends Domain #Module.mixOf Domain, PassingTones
    constructor: (opt) ->
      opt ?= {} #for being able to init without args
      
      #call Domain construct
      super opt

      @current_pitch = opt.current_pitch || @pitches[opt.current_index] || _a.pick_random_el @pitches
      @current_index = opt.current_index || @pitches.indexOf @current_pitch #index of @current_pitch in @pitches

      @melodicPatternGen = new MelodicPatternGen
        steps_array: [-4,-3,3,4]
        iterations: [2,3,4]
        cycle_step: [-3,-2,-1,1,2,3]
        pattern_length: [2,3,4,5,6] 

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

      pitch = @find_closest_pitch_from pitch
      @current_index = @indexOf pitch
      @current_pitch = @pitches[@current_index]

    get_current_degree: ->
      pitch_class_int = @current_pitch.value % 12
      for pci,i in @available_concrete()
        return @available_degrees_array()[i] if pci == pitch_class_int
      throw "get_current_degree can't find degree :s weird!"    

    set_melodic_context: (mode, degrees_functions) ->
      super mode, degrees_functions

      # when the melodic_context is changed,
      # the current pitch is assign to the closest pitch of new mel_context
      @set_current_pitch @find_closest_pitch_from @current_pitch 

    find_closest_pitch_from: (pitch) ->
      intervals= []
      for pval,i in @pitches_values() 
        intervals.push Math.abs(pitch.value - pval)

      min = Math.min.apply(Math,intervals)
      return @pitches[intervals.indexOf(min)]

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
            # when mode change occur during a pattern it could go out of bounds
            throw "out of bounds!! means that MelodicPatternGen#give_pattern doesn't works well"

        else
          @step_pattern2() 
          @next() 

    # random step from within a range [min..max] where min and max are steps, rep => repetition boolean
    drunk: (min,max,rep = false) ->

      @next = =>

        _min = min
        _max = max

        # take care of domain bounds
        _min++ while @current_index + _min < 0 
        _max-- while @current_index + _max >= @pitches.length
  
        arr = [_min.._max]

        unless rep
          zero_index = arr.indexOf 0
          arr.splice(zero_index,1)
        
        @step _a.sample arr 
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
      _a.sample @pitches
    
    # temp to try passing tones
    drunk_passing: (passing_size, broderie = false) ->

      dist_from_target_array = []

      @next = =>
        if dist_from_target_array.length == 0
          # pick a random pitch in main_pitches and assign it to current_pitch
          @set_current_pitch(_a.sample @main_pitches) 
          #get degree of current_pitch
          degree = @get_current_degree()
          #get degree passing profile
          profile = @passing_profile[degree.name]
          #compute a possible passing_set
          passing_set = _a.sample profile.passing_combinations[passing_size]
          passing_set = _a.scramble passing_set
          #convert it to 'dist_from_target_array'
          dist_from_target_array = @passing_set_to_dist_from_target_array degree,passing_set
          # add target code
          dist_from_target_array.push 0
          # if broderie add target code at begining
          dist_from_target_array = [0].concat dist_from_target_array if broderie

          #console.log dist_from_target_array
          #console.log passing_set

        # debugger
        pitch_val = @current_pitch.value + dist_from_target_array.splice(0,1)[0]
        pitch = new Pitch pitch_val 
        #console.log pitch
        return pitch








