define ["vendors/EventEmitter", "lib/core/RVal","lib/utils/Rational"], (EventEmitter)->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  Rational = AC.Utils.Rational
  RVal = AC.Core.RVal

  window.ee = new EventEmitter 

  class root.TimeLine

  	constructor: (opt) ->
  	  @origin_point = null #window.performance.now() when started
  	  @position =
  	    cycle: 0 
  	    bar: 0
  	    sub: new RVal(0,1)

  	  @resolution = opt.resolution || new Rational(1,4) #tic every sixtenth note

  	  @grid = opt.grid || [] #array of bars object

  	  @cycle = opt.cycle || false #does it loop or not
  	  @is_on = false

  	  @emitter = new EventEmitter

  	  #@rgen = opt.rgen
  	  #@mgen = opt.mgen
  	  #@hgen = opt.hgen

  	  @on_tic = => #simple function that log time on every tic [opt.on_tic || ()]
        console.log "#{ @position.bar + '>' + @position.sub.numer + '/' + @position.sub.denom  + ' mode: ' + @current_bar().h_dir_at(@position.sub).name}"

  	  # add event listeners
  	  @emitter.addListeners
  	    tic: @on_tic #[@rgen.bang, @on_tic]
  	    #start: @rgen.start


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
      if position then @position = position else @position = {cycle: 0,bar: 0, sub: new RVal(0,1)}

      @origin_point = window.performance.now()
      @is_on = true
      
      #init speed
      @speed = (60000 / @current_bar().bpm) * @current_bar().resolution.toFloat()

      @emitter.trigger('start',@)
      @emitter.trigger('tic',@) 
    
      instance = () =>

        @position.sub.add @current_bar().resolution
  
        if @position.sub.eq @current_bar().duration()
          @position.bar++

          if @cycle and @position.bar == @grid.length
            @position.bar = 0 
            @position.cycle++

          @speed = (60000 / @current_bar().bpm) * @current_bar().resolution.toFloat() #update speed in case of different bpm
          @position.sub = new RVal(0,1) #reset sub position
        
        @emitter.trigger('tic',@) #emit tic event and send timeline object to listeners (maybe to heavy... try a subset if it is)
  
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
  
    total: () ->
      @position.sub.plus @position.bar

    cycle_ms_duration: ->
      result = 0
      for b in @grid  
      	result+= b.ms_duration()
      return result

    previous_cycles_duration: ->
      @cycle_ms_duration() * @position.cycle

    previous_bars_duration: ->
      result = 0
      return 0 if @position.bar == 0 
      
      for i in [0..@position.bar-1]
        result+= @grid[i].ms_duration()
        
      return result 

    check_precision: () ->		
      real = window.performance.now() - @origin_point	     
      computed = @previous_cycles_duration() + @previous_bars_duration() + @current_bar().ms_duration_at(@position.sub)
      result = real - computed
      return result

    ########## helpers ###############
    
    current_bar: ->
      @grid[@position.bar]  



