define [
  "lib/core/base/RVal"
  "lib/utils/Rational"
  "lib/core/structure/Position"
  "lib/midi/play"
  ], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  Rational = AC.Utils.Rational
  RVal = AC.Core.RVal
  Position = AC.Core.Position
  Note= AC.Core.Note

  class root.TimeLine

    constructor: (opt) ->

      @origin_point = null #window.performance.now() when started

      @position = new Position
        cycle: 0 
        bar: 0
        sub: new RVal 0

      @resolution = opt.resolution || new Rational(1,4) #tic every sixtenth note by default

      @grid = opt.grid || [] #array of bars object

      @cycle = opt.cycle || false #does it loop or not
      @is_on = false

      @tracks = opt.tracks || [] #array of track objects

      @score = []

      @on_tic = => #simple function that log time on every tic [opt.on_tic || ()]
        console.log "#{ @position.bar + '>' + @position.sub.numer + '/' + @position.sub.denom }" 

    tic: ->
      #@on_tic()
      for t in @tracks  
        t.tic()

    start: (position) ->

      # if start position given then update @position
      if position then @position = position else @position = new Position {cycle: 0,bar: 0, sub: new RVal(0,1), timeline: @}

      @origin_point = window.performance.now()
      @is_on = true
      
      #init speed
      @speed = (60000 / @current_bar().bpm) * @current_bar().resolution.toFloat()

      @tic() 

    
      instance = =>
        
        prev_bar_index = @position.bar
        @position = @position.plus @resolution

        if prev_bar_index != @position.bar
          @speed = (60000 / @current_bar().bpm) * @current_bar().resolution.toFloat()

        @tic()
  
        diff = @check_precision()
        setTimeout instance, (@speed - diff) if @is_on
      
      setTimeout instance, @speed

      return
  
    stop:  ->
      @is_on = false
      for t in @tracks
        t.reset()
        #AC.MIDI.all_off()
        #t.composer.ahead = new RVal 0

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

    insert_bar: (bar ,index = 0, mult = 1) ->
      for i in [1..mult]
        _a.insert(@grid,index,bar)


    ########## PLAY ##################

    # # line => array of Note or [Note,Note,...](chord)
    # play_line: (line, midi_chan = 1) ->  

    #   line = [line] unless line instanceof Array # if single note wrap it

    #   for n in line
    #     if n instanceof Note
    #       AC.MIDI.simple_play
    #         channel: midi_chan
    #         pitch: n.pitch.value
    #         velocity: n.velocity
    #         duration: @positioned_rval_to_ms(n.position, n.duration)
    #         at: n.position.to_performance_time()
             
    #     #n must be a chord ([Note,Note,...])  
    #     else
    #       for cn in n
    #         AC.MIDI.simple_play
    #           channel: midi_chan
    #           pitch: cn.pitch.value
    #           velocity: cn.velocity
    #           duration: @positioned_rval_to_ms(cn.position, cn.duration)
    #           at: cn.position.to_performance_time()
             
  






