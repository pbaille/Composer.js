define [
  "lib/core/structure/Position"
  "lib/core/composer/Composer"
  "lib/midi/play"
  "vendors/ruby"
  "lib/utils/Utils"
  ], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  Position= AC.Core.Position
  RVal= AC.Core.RVal
  Composer= AC.Core.Composer 

  class root.Track

    constructor: (opt) ->  

      @midi_channel= opt.midi_channel || 1

      @directives= opt.directives || []
      @sort_directives() # sort directives based on their position

      @composer= opt.composer || new Composer # the object that receive directives while execution and dispatch them to generators
      @composer.track = this

      opt.midi_events ?= {}
      @midi_events=
        notes: opt.midi_events.notes || []
        messages: opt.midi_events.message || []

      @score = [] # past events are appended in this array while execution
      @queue = [] # queue of note to play

    tic: ->

      while @directives[0].position.le @composer.head_position()
      	@composer.apply_directive @directives[0] # send first directive to composer
      	@directives[0].position.cycle++ #increment cycle
      	@directives = _a.rotate(@directives,1) #send it to the last index  
      @composer.tic()	

      @play()

    sort_directives: ->
      @directives.sort (a,b) ->
      	a.position.ge b.position

    add_directive: (d) ->
      for dir,i in @directives
      	if d.position.lt dir.position
          debugger
          _a.insert(@directives,i,d)  
          break 	

    reset: ->
      dir.position.cycle = 0 for dir in @directives
      @sort_directives()      
      note.position.cycle = 0 for note in @midi_events.notes

    print_score: ->
      @score.map (x) ->
        "p:#{x.pitch.value} d:#{x.duration.numer}/#{x.duration.denom} at:#{x.position.sub.numer}/#{x.position.sub.denom} "   

    # schedule midi events just in time
    play: ->
      line_to_play = []

      # composed events
      while @queue[0].position.le timeline.position.plus new RVal 1,2
      	line_to_play.push @queue.shift()

      # hard coded events
      while @midi_events.notes[0].position.le timeline.position.plus new RVal 1,2
        line_to_play.push @midi_events.notes[0].clone() #had to clone it before increment pos.cycle
        @midi_events.notes[0].position.cycle++ #inc cycle for looping
        @midi_events.notes = _a.rotate(@midi_events.notes,1) #send it to last index

      if line_to_play.length isnt 0
        AC.MIDI.play_line line_to_play 

        
        
