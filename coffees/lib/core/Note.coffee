define ["lib/utils/Rational", "vendors/ruby"], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 
  # RATIONAL shortcut
  root.rat = (args...) ->
    new AC.Utils.Rational args...
  
  #########################################################################
  class root.MetaPitch
  
    constructor: (arg) ->
  
    	if typeof arg == 'string'
    	  @name = arg 
    	  @int = root.MetaPitch.hash[@name]
    	else
    	  for k,v of MetaPitch.hash
          if v == arg
            @name= k 
            @int= arg  
  
    #private
    @hash:
      "C" : 0
      "D" : 2
      "E" : 4
      "F" : 5
      "G" : 7
      "A" : 9
      "B" : 11
  
    @find_closest: (int) ->
    	result = _h.key @hash,int
    	if result then result else _h.key(@hash,int+1) + 'b'
  
  #########################################################################
  class root.Alteration
  
    constructor: (arg) ->
  
      hash=
        "bb": -2
        "b": -1
        "n": 0
        "#": 1
        "x": 2
  
      if typeof arg == 'string'
        @name= arg 
        @int= hash[arg]
      else 
        @name = _h.key hash,arg
        @int = arg
  
  #########################################################################
  class root.PitchClass
  
    constructor: (arg)->
  
    	unless typeof arg == 'string'
    	  arg = root.MetaPitch.find_closest arg
  		
    	mp= new root.MetaPitch(arg[0])
    	if (arg.slice(1,3)) then alt= new root.Alteration(arg.slice(1,3)) else alt = new root.Alteration("n")
    	@name = arg
    	@int = mp.int + alt.int
  
  #########################################################################
  class root.Pitch extends root.PitchClass
  
    constructor: (pitchClass, octave) ->
  
    	if typeof pitchClass == "string"
    	  p = pitchClass.split(" ")
    	  super p[0]
    	  if p[1]
    	    @octave = +p[1] 
    	  else if octave
    	    @octave = octave
    	  else
    	    @octave = 0 
    	  @int = @int + (octave+5)*12  
    	else
    	  super pitchClass%12
    	  @octave = octave || Math.floor pitchClass/12 - 5    
  		  @value = pitchClass%12 + ( @octave + 5 ) * 12

  #########################################################################
  class root.Note extends root.Pitch
  
    constructor: (pitch, vel = 60 , duration = 1, position = 0) ->
      @pitch = new root.Pitch pitch
      @velocity = vel
      @duration = duration
      @position = position
  
  #########################################################################
  # return root
  
  # #console.log "hello"
  # p = new Note(75, rat(2,3))
  # puts p         


