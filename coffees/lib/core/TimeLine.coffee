define [
  "vendors/EventEmitter"
  "lib/core/RVal"
  "lib/utils/Rational"
  "lib/core/Position"
  "lib/midi/play"
  ], (EventEmitter)->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  Rational = AC.Utils.Rational
  RVal = AC.Core.RVal
  Position = AC.Core.Position
  Note= AC.Core.Note

  window.ee = new EventEmitter 

  class root.TimeLine

    constructor: (opt) ->

      @origin_point = null #window.performance.now() when started

      @position = new Position
        cycle: 0 
        bar: 0
        sub: new RVal 0
        timeline: @

      @resolution = opt.resolution || new Rational(1,4) #tic every sixtenth note by default

      @grid = opt.grid || [] #array of bars object

      @cycle = opt.cycle || false #does it loop or not
      @is_on = false

      @emitter = new EventEmitter

      #@tracks = opt.tracks || [] #array of track objects

      @rgen = opt.rgen
      #@mgen = opt.mgen
      #@hgen = opt.hgen

      @on_tic = => #simple function that log time on every tic [opt.on_tic || ()]
        console.log "#{ @position.bar + '>' + @position.sub.numer + '/' + @position.sub.denom  + ' mode: ' + @current_bar().h_dir_at(@position.sub).name }"

      # add event listeners
      @emitter.addListeners
        tic: [@rgen.tic, @on_tic]
        start: @rgen.start


      ########################################################
      # @metronome = opt.metronome || new Metronome #linked metronome object
      #   bpm: 60 
      #   beats: 4 #bar of 4 beats
      #   unit: 4 #tic on every sixteenth
      #   on_click: -> #simple function that log time on every tic
      #     console.log ("#{@bars + ' > ' +@beats + ' > ' + @count}")
      ########################################################

    start: (position) ->

      # if start position given then update @position
      if position then @position = position else @position = new Position {cycle: 0,bar: 0, sub: new RVal(0,1), timeline: @}

      @origin_point = window.performance.now()
      @is_on = true
      
      #init speed
      @speed = (60000 / @current_bar().bpm) * @current_bar().resolution.toFloat()

      @emitter.trigger('start', [@] ) #pass to timeline object to listeners
      @emitter.trigger('tic') 
    
      instance = () =>

        # @position.sub.add @current_bar().resolution
  
        # if @position.sub.eq @current_bar().duration()
        #   @position.bar++

        #   if @cycle and @position.bar == @grid.length
        #     @position.bar = 0 
        #     @position.cycle++

        #   @speed = (60000 / @current_bar().bpm) * @current_bar().resolution.toFloat() #update speed in case of different bpm
        #   @position.sub = new RVal(0,1) #reset sub position
        
        prev_bar_index = @position.bar
        @position = @position.plus @resolution

        if prev_bar_index != @position.bar
          @speed = (60000 / @current_bar().bpm) * @current_bar().resolution.toFloat()

        @emitter.trigger('tic')
  
        diff = @check_precision()
        setTimeout instance, (@speed - diff) if @is_on
      
      setTimeout instance, @speed

      return
  
    stop: () ->
      # if @bpm #check if 'this' refer to Metronome instance
      #   @is_on = false
      # else
      #   console.log "this uncorrectly binded, please don't use #stop directly as callback" 

      # for l in @listeners  
      #   l.stop()

    check_precision: () ->		
      real = window.performance.now() - @origin_point	     
      computed = @position.total_time()
      result = real - computed
      return result

    # compute the duration in ms of a positioned rythmic value (RVal)
    positioned_rval_to_ms: (pos,rval) ->  
      return pos.rval_to_ms(rval)

    ########## helpers ###############
    
    current_bar: ->
      @grid[@position.bar]  

    ########## PLAY ##################

    # line => array of Note or [Note,Note,...](chord)
    play_line: (line, midi_chan) ->  

      line = [line] unless line instanceof Array # if single note wrap it

      for n in line
        if n instanceof Note
          AC.MIDI.simple_play
            channel: midi_chan || 1
            pitch: n.pitch.value
            velocity: n.velocity
            duration: @positioned_rval_to_ms(n.position, n.duration)
            at: n.position.to_performance_time()

          # console.log "*********************************************"
          # console.log n
          # console.log "duration"
          # console.log @positioned_rval_to_ms(n.position, n.duration) 
          # console.log "position"
          # console.log n.position.toString()
          # console.log "perf_time"
          # console.log n.position.to_performance_time() 
          # console.log "*********************************************"

             
        #n must be a chord ([Note,Note,...])  
        else
          for cn in n
            AC.MIDI.simple_play
              channel: midi_chan || 1
              pitch: cn.pitch.value
              velocity: cn.velocity
              duration: @positioned_rval_to_ms(cn.position, cn.duration)
              at: cn.position.to_performance_time()
             
  






