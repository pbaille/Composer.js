define ["lib/utils/Rational","lib/utils/Utils", "lib/core/Note", "lib/midi/play", "vendors/ruby"], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core  

  # RATIONAL shortcut
  rat = (args...) ->
    new AC.Utils.Rational args...  

  class root.RGen 

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
      #console.log "reset gen"
      @array = []
      @add dur_occ_objs if dur_occ_objs

    reset_clock: () ->

      @clock = rat(0,1)

    rvs_sync: (rvs_table) -> 
      @reset()
      _h.each rvs_table, (k,v) =>
        # hardcoded 4 is because of => ex: quarter note is 1 beat => 1/4 become 1
        @add {value: rat(4,k), occ: v}

    remove: (dur) ->

      rem_indexes = []
      for x,i in @array
        rem_indexes.push i if x.value.eq(dur)

      for x in rem_indexes
        @array.splice(x,1) 

    #craft an array of all possible denominators
    denoms: () ->

      results = [1] #insert 1 by default simplest subdiv

      @array.map (x) -> 

        return if x.occ == 0

        den = x.value.denom

        # return if already in results
        return if results.indexOf(den) != -1
        # extract base binary rythmn value
        bases_arr = _a.uniq(AC.Utils.factorise(den))

        # make an array for den and eventual den/poly for non binary values 
        if bases_arr[1]
          poly = bases_arr[1] # index 0 is 2 index 1 is poly base
          dens = [den, den/poly] # add  
        else
          dens = [den]

        for d in dens
          mod = 0
          while mod == 0
            results.push d if results.indexOf(d) == -1 #push if not already there
            mod = d % 2
            d /= 2

      results

    #bang method called on each metronome tic
    bang: (metronome) ->

      #temp to displace
      @origin = metronome.origin_point
      @bpm = metronome.bpm
      @current_time= metronome.total()

      #init @head_position in sync with metronome
      unless @head_position
        @head_position = @current_time.dup()

      #console.log @current_sub()

      # generate if head advance is less than streamLen
      if (@head_position.minus @current_time).lt(@streamLen)
        @insertion_point= @head_position.dup()
        @generate() 

    generate: () ->
      results = []

      while @head_position.minus(@current_time).lt(@streamLen)
        results.push @next()

      @melodize(results) if results 


    next: ->

      #fill pioche in respect of each value occ
      pioche = []
      for x in @available_vals()
        for i in [0..x.occ-1]
          pioche.push x.value

      #pick a random val in pioche and return it
      pioche = _a.shuffle(pioche)
      @head_position.add(pioche[0]) 
      pioche[0]

    available_vals: () ->

      results = []
      for x in @array
        if x.occ != 0
          # push value in result if value + @head_position is on a available subdivision
          cond1 = @denoms().indexOf(x.value.plus(@head_position).denom) >= 0

          #to avoid too much polyrythmn, TODO: turn it into a user param
          cond2 = () =>
            console.log "###################################"
            console.log "cond2 " + @current_sub()
            console.log "x= " + x.value.denom
            if @current_sub() % 2 == 0 or @current_sub() == 1
              console.log "bin"
              true
            else
              console.log "other " + _a.last(AC.Utils.factorise x.value.denom)
              _a.last(AC.Utils.factorise x.value.denom) == _a.last(AC.Utils.factorise @current_sub())

          results.push x if cond1 and cond2()

      # head unable to resolve on an available subdivision, 
      # have to resolve it with non available value
      if results.length == 0
        results.push @resolve_head()

      return results

    #called if no rythmn values available, 
    #it compute a value to resolve the head position on availables subdivisions
    resolve_head: () ->
      console.log "resolve head"
      sub = @current_sub()
      value = rat(0,1)
      while @denoms().indexOf(value.plus(@head_position).denom) < 0
        value.add(rat(1,sub))
      console.log "value= " + value
      console.log "head= " + @head_position
      {value: value, occ: 1} 

    current_sub: () ->
      @head_position.denom   

    #TEMP to ear results
    melodize: (rythmic_line) ->
      line = []
      for duration in rythmic_line
        pitch = Math.floor(Math.random()*30 + 50)
        vel = Math.floor(Math.random()*30 + 40)
        #console.log "test"
        #console.log duration.times(rat(60, @bpm))
        n = new AC.Core.Note(pitch, vel, duration.times(rat(60, @bpm)))
        line.push(n)

      @send_to_midi line  

    send_to_midi: (line, position) ->
      AC.MIDI.line
        notes: line
        at: @origin + @insertion_point.times(rat(60, @bpm)).toFloat() * 1000

    pause: () ->  

  # console.log "RGen test ################################"

  # rgen = new AC.Core.RGen
  #   prob_array: [
  #     {value: rat(1,2), occ: 1}
  #     {value: rat(1,4), occ: 1}
  #     {value: rat(3,8), occ: 3}
  #     {value: rat(1,3), occ: 1}
  #     {value: rat(1,6), occ: 1}
  #   ]
  #   streamLen: rat(2,1)  

  # console.log "denoms" + rgen.denoms()

  # console.log "######################################"    




