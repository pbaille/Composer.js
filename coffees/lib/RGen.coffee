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

      f() for [1..n]

      @plan_next_stream(start_time)
      @melodize result

    plan_next_stream: (start_time) ->
      
      at = (@clock.toFloat() - start_time) * 1000
      
      cb = () =>
        @next @streamLen
      setTimeout cb, at

    start: () ->
      @time_origin = window.performance.now()
      @reset_clock()
      @next @streamLen,1

    #TEMP to ear results
    melodize: (rythmic_line) ->
      line = []
      for duration in rythmic_line
        pitch = Math.floor(Math.random()*30 + 40)
        vel = Math.floor(Math.random()*30 + 40)
        n = new Note(pitch, vel, duration)
        line.push(n)

      @send_to_midi line  

    send_to_midi: (line, position) ->
      midi.line
        notes: line
        at: @clock.toFloat() * 1000 + @time_origin

    pause: () ->  

  class root.RGen2 

    constructor: (opt) ->

      @array = opt.prob_array || [] #array of {value: Rational_denom, occ: integer}
      @head_position = null #Rational
      @streamLen = opt.streamLen #Rational

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

    #bang method called on each metronome tic
    bang: (metronome) ->

      #temp to displace
      @origin = metronome.origin_point
      @bpm = metronome.bpm
      @current_time= metronome.total()

      unless @head_position
        @head_position = @current_time.dup()

      r = @head_position.minus @current_time
      console.log r.numer + '/' + r.denom
      console.log "insertion" + @insertion_point.numer + '/' + @insertion_point.denom if @insertion_point

      if (@head_position.minus @current_time).lt(@streamLen)
        @insertion_point= @head_position.dup()
        @generate() 

    generate: () ->
      results = []

      while @head_position.minus(@current_time).lt(@streamLen)
        results.push @next()

      @melodize(results) if results 


    next: ->

      available_vals = []
      for x in @array
        if x.occ != 0
          available_vals.push x if @denoms().indexOf(x.value.plus(@head_position).denom) >= 0

      pioche = []
      for x in available_vals
        for i in [0..x.occ-1]
          pioche.push x.value

      pioche = _a.shuffle(pioche)
      @head_position.add(pioche[0]) 
      pioche[0]

    # start: () ->
    #   @time_origin = window.performance.now()
    #   @reset_clock()
    #   @next @streamLen,1

    #TEMP to ear results
    melodize: (rythmic_line) ->
      line = []
      for duration in rythmic_line
        pitch = Math.floor(Math.random()*30 + 40)
        vel = Math.floor(Math.random()*30 + 40)
        console.log "test"
        console.log duration.times(rat(60, @bpm))
        n = new Note(pitch, vel, duration.times(rat(60, @bpm)))
        line.push(n)

      @send_to_midi line  

    send_to_midi: (line, position) ->
      midi.line
        notes: line
        at: @origin + @insertion_point.times(rat(60, @bpm)).toFloat() * 1000

    pause: () ->  



