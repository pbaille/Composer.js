define ["lib/core/base/Mode"], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  MK= root.MK
  Pitch = root.Pitch
  Mode= AC.Core.Mode

  #maybe change name to melodic domain
  class root.Domain

    constructor: (opt) -> 
      @mode = opt.mode
      @bounds = opt.bounds
      @pitches = @pitches_calc()
      @main_struct = opt.main_struct || @mode.prio[0..3]

    pitches_calc: ->
      res = []
      for x in [@bounds[0]..@bounds[1]]
        res.push new Pitch(x) if @mode.concrete.indexOf(x%12) >= 0
      return res
        
    set_bounds: (args...) ->
      if args.length == 1 then @bounds = args else @bounds = [args[0],args[1]]

    set_up_bound: (up) ->
      @bounds[1]= up  

    set_down_bound: (down) ->
      @bounds[0]= down  

    pitches_values: ->
      @pitches.map (x) -> x.value 

    set_mode: (m) ->
      if m instanceof Mode
        @mode = m
      else
        @mode = new Mode m     
      @pitches = @pitches_calc()

    main_pitches: ->
      result = []
      for p in @pitches
        result.push p if @main_struct.indexOf(p.value % 12) >= 0
      result

        





      


