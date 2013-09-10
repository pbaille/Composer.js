define ["lib/Rational","lib/Note", "../../js/vendors/ruby"], (Rational,Note,ruby) ->

  if typeof global != "undefined" && global != null 
    root= global
  else
    root= window  
  # RATIONAL shortcut
  root.rat = (args...) ->
    new Rational args...

  RGen = root.RGen
  
  class RGen  

  	constructor: (dur_occ_obj_arr) ->
  	  @array = dur_occ_obj_arr
  	  @clock = rat(0,1)

  	add: (dur_occ_obj) ->

  	  unless dur_occ_obj.length
        dur_occ_obj = [dur_occ_obj]

      for x in dur_occ_obj 
  	    @remove x.value
  	    @array.push x

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

  	next: (n) ->
  	  result = []
  	  f = () =>
  	    available_vals = []
  	    for x in @array
  	      available_vals.push x if @denoms().indexOf(x.value.plus(@clock).denom) >= 0
  
  	    pioche = []
  	    for x in available_vals
  	      for i in [0..x.occ-1]
  	        pioche.push x.value
  
  	    pioche = _a.shuffle(pioche)
  	    result.push pioche[0]
  	    @clock.add(pioche[0])	

  	  f() for [1..n]
  	  result





