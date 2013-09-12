define ["lib/Rational","lib/Note", "lib/play", "vendors/ruby"], (Rational,note,midi,ruby) ->

  if typeof global != "undefined" && global != null 
    root= global
  else
    root= window  
  # RATIONAL shortcut
  root.rat = (args...) ->
    new Rational args...

  class root.RGen  

    constructor: (dur_occ_obj_arr , streamLen = 10) ->
      @array = dur_occ_obj_arr || []
      @clock = rat(0,1)
      @streamLen = streamLen

    add: (dur_occ_obj) ->

      unless dur_occ_obj.length
        dur_occ_obj = [dur_occ_obj]

      for x in dur_occ_obj 
        @remove x.value
        @array.push x

    reset: (dur_occ_objs) ->
      console.log "reset gen"
      @array = []
      @add dur_occ_objs if dur_occ_objs


    reset_clock: () ->
      @clock = rat(0,1)

    rvs_sync: (rvs_table) -> 
      @reset()
      _h.each rvs_table, (k,v) =>
        @add {value: rat(1,k), occ: v}

    remove: (dur) ->

      rem_indexes = []
      for x,i in @array
        rem_indexes.push i if x.value.eq(dur)

      for x in rem_indexes
        @array.splice(x,1) 

    #craft an array of all possible denominators
    denoms: () ->
      res = []
      @array.map (x) -> 
        mod = 0
        den = x.value.denom
        while mod == 0
          res.push den if res.indexOf(den) == -1 #push if not already there
          mod = den % 2
          den /= 2
      res

    next: (n, plan_offset) ->
      #console.log "next"
      #console.log @
      #console.log @clock

      result = []

      start_time = plan_offset || @clock.toFloat()
      f = () =>
        available_vals = []
        for x in @array
          if x.occ != 0
            available_vals.push x if @denoms().indexOf(x.value.plus(@clock).denom) >= 0
  
        pioche = []
        for x in available_vals
          for i in [0..x.occ-1]
            pioche.push x.value
  
        pioche = _a.shuffle(pioche)
        result.push pioche[0]
        @clock.add(pioche[0])	
        #console.log @clock

      f() for [1..n]

      @plan_next_stream(start_time)
      @melodize result

    plan_next_stream: (start_time) ->
      #register next stream computation at middle time
      #console.log "plan..."
      #console.log @clock
      at = (@clock.toFloat() - start_time) * 1000
      #at = @time_origin
      #console.log @clock
      cb = () =>
        @next @streamLen
      setTimeout cb, at

    play: () ->
      @time_origin = window.performance.now()
      @reset_clock()
      @next @streamLen

    #TEMP to ear results
    melodize: (rythmic_line) ->
      line = []
      for duration in rythmic_line
        pitch = Math.floor(Math.random()*30 + 40)
        vel = Math.floor(Math.random()*30 + 40)
        n = new Note(pitch, vel, duration)
        line.push(n)

      @send_to_midi line  

    send_to_midi: (line) ->
      midi.line
        notes: line
        #at: 1000

    pause: () ->  





