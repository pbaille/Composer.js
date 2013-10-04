define [
  "lib/core/structure/Position"
  "lib/core/composer/Composer"
  ], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  Position= AC.Core.Position
  Composer= AC.Core.Composer  

  class root.Track

    constructor: (opt) ->    
      @midi_channel= opt.midi_channel || 1
      @directives= opt.directives || []
      @sort_directives() # sort directives based on their position
      @composer= opt.composer || new Composer # the object that receive directives while execution and dispatch them to generators
      @score = [] # past events are appended in this array while execution

    tic: ->
      while @directives[0].position.le @composer.head_position()
      	@composer.apply_directive @directives[0] # send first directive to composer
      	@directives[0].position.cycle++ #increment cycle
      	@directives = _a.rotate(@directives,1) #send it to the last index
      @composer.tic()	

    sort_directives: ->
      @directives.sort (a,b) ->
      	a.position.ge b.position

    add_directive: (d) ->
      for dir,i in @directives
      	if d.position.lt dir.position
          debugger
          _a.insert(@directives,i,d)  
          break 	
      	
        
