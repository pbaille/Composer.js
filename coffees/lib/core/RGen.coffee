define ["lib/utils/Rational","lib/core/RVal","lib/utils/Utils", "lib/core/Note", "lib/midi/play", "vendors/ruby"], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core  

  # RATIONAL shortcut
  rat = (args...) ->
    new AC.Utils.Rational args...

  RVal = AC.Core.RVal
  Rational = AC.Utils.Rational    

  class root.RGen

    constructor: (opt) ->
      opt = {} unless opt
      @array = opt.prob_array || [] #array of {value: Rational_denom, occ: integer}

    # add: (dur_occ_obj) ->

    #   unless dur_occ_obj.length
    #     dur_occ_obj = [dur_occ_obj]

    #   for x in dur_occ_obj 
    #     @remove x.value
    #     @array.push x

    # reset: (dur_occ_objs) ->
    #   #console.log "reset gen"
    #   @array = []
    #   @add dur_occ_objs if dur_occ_objs

    # rvs_sync: (rvs_table) -> 
    #   @reset()
    #   _h.each rvs_table, (k,v) =>
    #     # hardcoded 4 is because of => ex: quarter note is 1 beat => 1/4 become 1
    #     @add {value: rat(4,k), occ: v}

    # remove: (dur) ->

    #   rem_indexes = []
    #   for x,i in @array
    #     rem_indexes.push i if x.value.eq(dur)

    #   for x in rem_indexes
    #     @array.splice(x,1) 

    set_prob_array: (rval_occ_objects_arr) ->
      @array = rval_occ_objects_arr
         
    ############################ Should be private ########################

    generate: ->
      results = []

      while @composer.ahead.lt @composer.advance 
        results.push @next()

      #@melodize(results) if results #temp just to test
      return results

    next: ->

      position = timeline.position.plus @composer.ahead

      #fill pioche in respect of each value occ
      pioche = []
      for x in @available_vals()
        for i in [0..x.occ-1]
          pioche.push x.rval

      #pick a random val in pioche and return it
      pioche = _a.shuffle(pioche)
      @composer.ahead.add(pioche[0]) 

      console.log "pos: " + position.sub.toString()
      console.log "rv: " + pioche[0].toString()
      console.log "ahead: " + @composer.ahead.toString()
      console.log "mode: " + @composer.mgen.mode.name

      return {position: position, rval: pioche[0]}

    available_vals: ->

      results = []
      for x in @array
        if x.occ != 0
          # push value in result if value + @head_position is on a available subdivision
          cond1 = x.rval.allowed_subs().indexOf(x.rval.plus(timeline.position.sub.plus(@composer.ahead)).denom) >= 0

          results.push x if cond1 #and cond2

      # head unable to resolve on an available subdivision, 
      # have to resolve it with non available value
      if results.length == 0
        results.push @resolve_head()

      return results

    #called if no rythmn values available, 
    #it compute a value to resolve the head position on availables subdivisions
    resolve_head: ->

      throw " have to implement Rgen#resolve_head "

    #   console.log "resolve head"
    #   sub = @head_position().sub
    #   value = new RVal 0
    #   while @available_vals().indexOf(value.plus(@head_position).denom) < 0
    #     value.add(rat(1,sub))
    #   console.log "value= " + value
    #   console.log "head= " + @head_position
    #   {value: value, occ: 1} 

    # head_position: ->
    #   @timeline.position.plus(@ahead)





