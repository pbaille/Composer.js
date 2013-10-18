define ["lib/core/base/Mode","lib/core/base/MelodicContext"], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  MK= root.MK
  Pitch = root.Pitch
  Mode= AC.Core.Mode
  MelodicContext= AC.Core.MelodicContext

  #maybe change name to melodic domain
  class root.Domain extends MelodicContext

    constructor: (opt) ->

      super opt

      @bounds = opt.bounds || [50,80]
      @pitches = @pitches_calc()
      @main_pitches = @main_pitches_calc()

    pitches_calc: ->
      res = []
      available_concrete = @available_concrete()
      for x in [@bounds[0]..@bounds[1]]
        res.push new Pitch(x) if available_concrete.indexOf(x%12) >= 0
      return res
        
    set_bounds: (args...) ->
      if args.length == 1 then @bounds = args else @bounds = [args[0],args[1]]

    set_up_bound: (up) ->
      @bounds[1]= up  

    set_down_bound: (down) ->
      @bounds[0]= down  

    pitches_values: ->
      @pitches.map (x) -> x.value 

    set_melodic_context: (mode, degrees_functions) ->
      @mode = mode

      if degrees_functions
        set_degrees_functions degrees_functions
      else  
        @default_degrees_functions_init()  

      @pitches = @pitches_calc()
      @main_pitches = @main_pitches_calc()

    set_degrees_functions: (degrees_functions) ->  
      super degrees_functions
      @pitches = @pitches_calc()
      @main_pitches = @main_pitches_calc()

    main_pitches_calc: ->
      result = []
      main_concrete = @main_concrete()
      for p in @pitches
        result.push p if main_concrete.indexOf(p.value % 12) >= 0
      result

    # select: (pitch) ->
    #   sel = @pitches.filter (x) -> x.eq(pitch)  
    #   return sel[0]

    # return @pitches index of a given pitch
    indexOf: (pitch) ->
      index = undefined
      for p,i in @pitches
        if pitch.eq p 
          index = i
          break

      return index

        





      


