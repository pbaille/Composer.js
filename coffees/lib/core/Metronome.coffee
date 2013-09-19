# original code from http://www.sitepoint.com/creating-accurate-timers-in-javascript/

# doTimer = (length, resolution, oninstance, oncomplete) ->

#   steps = (length / 100) * (resolution / 10)
#   speed = length / steps
#   count = 0
#   start = new Date().getTime()

#   instance = () ->
#     if count++ == steps
#       oncomplete(steps, count)
#     else
#       oninstance(steps, count)
#       diff = (new Date().getTime() - start) - (count * speed)
#       setTimeout instance, (speed - diff)
  
#   setTimeout instance, speed

define [], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  class root.Metronome
  
    constructor: (opt) ->
      @bpm= opt.bpm
      @beats= opt.beats
      @unit= opt.unit
      @on_click= opt.on_click
      @listeners= opt.listeners || []
  
    start: () ->
      
      @origin_point = window.performance.now()
      console.log "perf" + window.performance.now()
      console.log "date" + new Date().getTime()
      @is_on = true
      @bars = 0
      @count = 0
  
      @speed = 60000 / (@bpm * @unit)

      console.log "speed" + @speed
      console.log "precision" + @check_precision()

      @on_click(@beats , @unit , @count) if @on_click 
  
      for l in @listeners
        l.start(@)
        l.bang(@)
    
      instance = () =>
  
        @count++
  
        if @count == @beats * @unit
          @bars++
          @count = 0
        
        @on_click(@beats , @unit , @count) if @on_click 

        for l in @listeners
          l.bang(@)
  
        diff = @check_precision()
        #console.log "diff " + diff
        setTimeout instance, (@speed - diff) if @is_on
      
      setTimeout instance, @speed
  
    stop: () ->
      if @bpm #check if 'this' refer to Metronome instance
        @is_on = false
      else
        console.log "this uncorrectly binded, please don't use #stop directly as callback" 

      for l in @listeners  
        l.stop()
  
    total: () ->
      rat(@count,@beats * @unit).plus(@bars).times(@beats)

    check_precision: () ->
      ( window.performance.now() - @origin_point ) - @total().times(rat(60,@bpm)).toFloat() * 1000 

  return AC.Core.Metronome    
  
  
  ######### TEST ##########

  # oc = (beats , unit ,count) ->
  #   console.log count + "/" + (beats * unit)
  
  # m = new Metronome 
  #   bpm:60
  #   beats: 4
  #   unit: 2
  #   on_click: oc

  # m.start()
  
  # stop = ->
  #   m.stop()
  
  # setTimeout stop , 5000

  ########################################

# #call #bang on every listeners at @frequency(times/second)
# class MainLoop

#   constructor: (@frequency, @listeners) ->

#   start: () ->
    
#     @is_on = true
#     @count = 0

#     speed = 1000 / @frequency
#     start = new Date().getTime()

#     for l in @listeners
#       l.bang()

#     instance = () =>

#       @count++
#       for l in @listeners
#         l.bang()

#       diff = (new Date().getTime() - start) - (@count * speed)
#       setTimeout instance, (speed - diff) if @is_on
    
#     setTimeout instance, speed

#   stop: () ->
#     if @frequency #check if 'this' refer to MainLoop instance
#       @is_on = false
#     else
#       console.log "this uncorrectly binded, please don't use #stop directly as callback"  

# # obj1 = {attr: "hello"}
# # obj1.bang = () ->
# #   console.log @attr

# # obj2 = {attr: "world"}
# # obj2.bang = () ->
# #   console.log @attr

# # ml = new MainLoop 2, [obj1, obj2]
# # ml.start()

