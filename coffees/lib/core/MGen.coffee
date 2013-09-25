define ["lib/core/Domain","vendors/ruby"], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  Domain = AC.Core.Domain
  Mode = AC.Core.Mode  
    
  class root.MGen extends Domain
    constructor: (opt) ->
      opt= {} unless opt #for being able to init without args
      bounds = opt.bounds || [50,80] # assign or default
      mode = opt.mode || new Mode "C Lyd" # assign or default
      super(mode, bounds) #call Domain constructor
      @composer = null

    melodize: (positioned_rvals_arr) ->
      line = []
      for pos_rval in positioned_rvals_arr
        pitch = @pitchify(pos_rval)
        vel = Math.floor(Math.random()*30 + 40)
        n = new AC.Core.Note(pitch, vel, pos_rval.rval, pos_rval.position)
        line.push(n)

      timeline.play_line line  

    pitchify: (pos_rval) ->
      pioche = _a.shuffle @pitches_values()
      return pioche[0]
        

    