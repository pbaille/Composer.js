define ["lib/utils/Combinatorics", "lib/utils/Array_adds", "vendors/ruby"], ->
  
  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  DomainPartition = AC.Utils.DomainPartition 
  
  class root.MelodicPattern

  	constructor: (opt) ->
  	  @step_sequence= opt.step_sequence #int array	
  	  @iterations= opt.iterations || 1 #int, nb of cycles
  	  
  	  @count = 
  	    step: 0
  	    cycle: 0

  	cycle_step: ->
  	  _a.somme @step_sequence  

  	total_sequence: ->
  	  result = []
  	  for i in [1..@iterations]    
  	  	for s in @step_sequence
  	  	  result.push s

  	  return result	  
    
    length: ->
      @step_sequence.length * @iterations

    cycle_amplitude: ->
      min = 0
      max = 0
      current = 0
      for s in @step_sequence   
        current += s
        min = current if current < min
        max = current if current > max
      return [min,max] 

    amplitude: ->
      min = 0
      max = 0
      current = 0
      for s in @total_sequence()
        current += s
        min = current if current < min
        max = current if current > max
      return [min,max] 
       
  	next: ->

  	  step = @step_sequence[@count.step]
  	  @count.step++
  	  if @count.step == @step_sequence.length
  	  	@count.step = 0
  	  	@count.cycle++

  	  if @count.cycle >= @iterations and @count.step >= 1
  	  	return false
  	  else
  	    return step	

    #return array of MelodicPattern object based on @step_sequence.unique_permutations
    permutations: ->
      results = []
      stepseq_perms = R(@step_sequence).unique_permutation()

      for step_seq in stepseq_perms
        results.push new root.MelodicPattern
          step_sequence: step_seq
          iterations: @iterations

      return results    
          

  ##############################################################	    

  class root.MelodicPatternGen 

    constructor: (opt) ->
      @steps_array= opt.steps_array #array of possible steps
      @iterations= opt.iterations #array
      @range= opt.range || null #array
      @cycle_step= opt.cycle_step #array
      @pattern_length= opt.pattern_length #array

      @patterns= []
      @patterns_calc() 

    patterns_calc: ->
      for i in @cycle_step
      	for l in @pattern_length
          dp = new DomainPartition @steps_array, l, i 
          for r in dp.results
          	@patterns.push new root.MelodicPattern
          	  step_sequence: r

    give_pattern: (bounds_from_current_pitch) ->

      # take the first pattern that fits in the melodic domain
      if bounds_from_current_pitch
        for pat in _a.scramble @patterns 	
          for mp in _a.scramble pat.permutations()
            for i in _a.scramble @iterations
  
              bounds = mp.cycle_amplitude()
  
              #calcul total amplitude with given iteration number (i)
              cycle_step = mp.cycle_step()
              if cycle_step < 0
                bounds[0] += i * cycle_step
              else if cycle_step > 0 
                bounds[1] += i * cycle_step
  
              if bounds_from_current_pitch[0] <= bounds[0] and bounds_from_current_pitch[1] >= bounds[1]  
                mp.iterations = i
                mp.count = {step: 0, cycle: 0}
                return mp

      else	
        pat = {}
        pat = _a.pick_random_el @patterns
        pat.iterations = _a.pick_random_el @iterations
        return pat


