define ["lib/core/Mode", "vendors/ruby"], ->
  
  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  MK= root.MK
  Mode = root.Mode

  class root.HarmonicContext
    constructor: (o) ->
      @current= new Mode o
      @center= @current.mother_mode()
      @function= "T"

    #***************************** MOVES *****************************************

    abs_move: (args...) ->
      new_mother_root_name = _h.key(MK.PITCHES,((@center.root.int + MK.MODAL_MOVES[args[0]])%12))
      @current.set_mother( new_mother_root_name + " " + @current.mother.name.split(' ')[1])
      @function = args[0]

      if args[1]
        if typeof args[1] == "string" then @relative(args[1]) else @intra_abs_move(args[1])

    rel_move: (args...) ->
      @current.transpose MK.MODAL_MOVES[args[0]]
      if args[1]
        if typeof args[1] == "string" then @relative(args[1]) else @intra_abs_move(args[1])

      dist = (@current.mother.root - @center.mother.root) % 12
      @function= _h.key MK.MODAL_MOVES, dist

    intra_abs_move: (n) ->
      @current.intra_abs_move n
    
    intra_rel_move: (n) ->
      @current.intra_rel_move n

    relative: (mode_name) ->
      @current.relative mode_name  

    #***************************************************************************

    centerize: ->
      @center= new Mode @current.mother.name

    set_center: (o) ->
      @center= new Mode o
      dist = (@current.mother.root - @center.mother.root) % 12
      @function= _h.key MK.MODAL_MOVES, dist




