define [
  "lib/core/base/Constants"
  "lib/core/base/Mode"
  "vendors/ruby"
  "lib/utils/Utils"
  "lib/utils/Array_adds"
  ], ->
  
  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  Mode = AC.Core.Mode 
  MK = AC.Core.MK

  # wrap a Mode object with a degrees_functions hash
  # degrees_functions state the melodic function of each degree ("main", "passing", "disabled")(default to "passing")
  class root.MelodicContext

  	# opt.degrees_function or 
    # opt.main_degrees and opt.disabled_degrees 
    # must be passed
    constructor: (opt) ->
      if opt.mode
        if opt.mode instanceof Mode
          @mode = opt.mode 
        #if no mode given then create new mode with opt and default degrees_functions  
        else @mode = new Mode opt 
      else @mode = new Mode "C Lyd" 
       
      @degrees_functions = {}

      # default degrees_functions init
      unless opt.degrees_functions or opt.main_degrees
        @default_degrees_functions_init() 

      # set degrees_functions      
      else      
        for k,v of @mode.degrees
          # if degrees_functions object given
          if opt.degrees_functions
            @set_degrees_functions opt.degrees_functions
            
          else if opt.main_degrees and opt.main_degrees.indexOf(v.generic_name) >= 0 
            v.melodic_function = "main" # extend degree objects with melodic_function property
          else if opt.disabled_degrees and opt.disabled_degrees.indexOf(v.generic_name) >= 0 
            v.melodic_function = "disabled" 
          else
            v.melodic_function = "passing"
            
          @degrees_functions[k] = v

      @passing_profile= @passing_profile_calc()
          

    default_degrees_functions_init: ->
      for k,v of @mode.degrees
        if @mode.prio[0..3].indexOf(v.dist) >=0 #@mode.prio include v.dist
          v.melodic_function = "main"
          @degrees_functions[k] = v
        else  
          v.melodic_function = "passing"
          @degrees_functions[k] = v 

    set_degrees_functions: (degrees_functions) ->  
      for k,v of @mode.degrees         
        if degrees_functions[k] 
          v.melodic_function = degrees_functions[k] # extend degree objects with melodic_function property
        else v.melodic_function = "passing" #default to "passing" 

        @degrees_functions[k] = v 

    ######### passing_profile related #########
    
    passing_profile_calc: ->
      # debugger
      res = {}	
      main_degrees = @main_degrees() 
      length = main_degrees.length
      for k,v of main_degrees
      	res[v.name] = 
      	  main_up: @main_up(v)
      	  step_up: @step_up(v)
      	  diat_up: @diat_up(v)
      	  chrom_up: undefined #have to do something with that
      	  main_down: @main_down(v)
      	  step_down: @step_down(v)
      	  diat_down: @diat_down(v)
      	  chrom_down: undefined #and that

      	current_degree = res[v.name]

      	# remove steps when have to (if main == diat then step is non sense)
      	if current_degree.main_up.eq current_degree.diat_up
      	  current_degree.step_up = null
      	if current_degree.main_down.eq current_degree.diat_down
      	  current_degree.step_down = null

      	current_degree.passing_combinations= @passing_combinations_calc current_degree

      return res

    passing_combinations_calc: (degree_passing_env)->
      chunked_types = []
      final_result = {}
      prev = null
      for type in ["main_up","step_up","diat_up","diat_down", "step_down", "main_down"]
        if degree_passing_env[type]
          current = new AC.Core.Degree degree_passing_env[type].name
          if prev and prev.eq current 
            _a.last(chunked_types).push type
          else chunked_types.push [type] 
          prev = current

      # compute sub group from size 2 to size max    
      for size in [2..chunked_types.length]
      	sub_group_combinations = _a.combination chunked_types,size
      	final_result[size]= []

      	for x in sub_group_combinations
      	  final_result[size].push comb for comb in _a.comb_zip x #from Array_adds combinatorics section  

      return final_result

    passing_set_to_dist_from_target_array: (target_degree ,passing_set) ->
      degree_profile = @passing_profile[target_degree.name]
      result = []
      #debugger
      for type in passing_set
        if type[type.length-1] == "n" #direction == down
          result.push(target_degree.dist_down_to(degree_profile[type]) * -1)
        else if type[type.length-1] == "p" #direction is up
          result.push target_degree.dist_up_to(degree_profile[type])
        else #type is self (target)
          result.push 0
      return result  

    
    #### passing types selectors ######

    main_up: (degree) ->  	
      md = @main_degrees_array()
      index = @find_degree(degree, md)
      if index != -1
        return md[(index+1)%md.length]
      else false

    step_up: (degree) ->  	 
      ad = @available_degrees_array()
      index = @find_degree(degree, ad)
      if index != -1
        return ad[(index+2)%ad.length]
      else false

    diat_up: (degree) ->  	 
      ad = @available_degrees_array()
      index = @find_degree(degree, ad)
      if index != -1
        return ad[(index+1)%ad.length]
      else false

    main_down: (degree) ->  	  	
      md = @main_degrees_array()
      index = @find_degree(degree, md)
      if index != -1
        return md[(index-1+md.length)%md.length]
      else false

    step_down: (degree) ->  	 
      ad = @available_degrees_array()
      index = @find_degree(degree, ad)
      if index != -1 
        return ad[(index-2+ad.length)%ad.length]
      else false 

    diat_down: (degree) ->  	 
      ad = @available_degrees_array()
      index = @find_degree(degree, ad)
      if index != -1
        return ad[(index-1+ad.length)%ad.length]
      else false

    find_degree: (degree, degree_array) ->
      index = -1
      for d,i in degree_array
      	if d.eq degree
      	  index = i
      	  break
      return index



    
    ######### melodic_function based sub groups ##########

    # hash #
    main_degrees: ->
      result = {}	
      for k,v of @degrees_functions
        result[k]= v if v.melodic_function == "main"
      return result  
    passing_degrees: ->
      result = {}	
      for k,v of @degrees_functions
        result[k]= v if v.melodic_function == "passing"
      return result  
    disabled_degrees: ->  
      result = {}	
      for k,v of @degrees_functions
        result[k]= v if  v.melodic_function == "disabled"
      return result  
    available_degrees: ->
      AC.Utils.merge @main_degrees(), @passing_degrees()

    # arrays #
    main_degrees_array: ->
      @degrees_array_from_melodic_function "main"
    passing_degrees_array: ->
      @degrees_array_from_melodic_function "passing"
    disabled_degrees_array: ->  
      @degrees_array_from_melodic_function "disabled"
    available_degrees_array: ->
      @degrees_array_from_melodic_function "disabled", false
    
    # if select is true it select given type degrees else it reject them 
    degrees_array_from_melodic_function: (type, select= true) ->
      result = []	
      for gen_deg in MK.ABSTRACT_DEGREES
        deg = @degrees_functions[gen_deg]
        if select
          result.push deg if deg.melodic_function == type
        else result.push deg if deg.melodic_function != type
      return result

    # return array of int (pitchclass.int)
    main_concrete: ->
      @main_degrees_array().map (x) => @mode.degree_int x
    passing_concrete: ->
      @passing_degrees_array().map (x) => @mode.degree_int x	
    disabled_concrete: -> 
      @disabled_degrees_array().map (x) => @mode.degree_int x 
    available_concrete: ->
      @available_degrees_array().map (x) => @mode.degree_int x



