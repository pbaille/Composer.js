define ["lib/core/Mode"], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  MK= root.MK
  Pitch = root.Pitch
  Mode= AC.Core.Mode

  class root.Domain
  	constructor: (@mode,@bounds) -> #Mode object and [low,up]
  	  @pitches = []
  	  for x in [bounds[0]..bounds[1]]
  	    @pitches.push new Pitch(x) if @mode.concrete.indexOf(x%12) >= 0

  	set_bounds: (args...) ->
  	  if args.length == 1 then @bounds = args else @bounds = [args[0],args[1]]

  	set_up_bound: (up) ->
  	  @bounds[1]= up  

  	set_down_bound: (down) ->
  	  @bounds[0]= down  

  	pitches_values: ->
  	  @pitches.map (x) -> x.value  

