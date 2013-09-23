define [], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core
    
  class root.MGen
    constructor: () ->

    start: (tl) ->
      @timeline = tl	

    melodize: (positioned_rvals_arr) ->
      line = []
      for pos_rval in positioned_rvals_arr
        pitch = @pitchify(pos_rval)
        vel = Math.floor(Math.random()*30 + 40)
        n = new AC.Core.Note(pitch, vel, pos_rval.rval, pos_rval.position)
        line.push(n)

      @timeline.play_line line  

    pitchify: (pos_rval) ->
        

    