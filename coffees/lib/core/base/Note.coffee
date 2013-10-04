define ["lib/utils/Rational","lib/core/base/RVal","lib/core/structure/Position", "vendors/ruby"], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  RVal = AC.Core.RVal
  Position = AC.Core.Position
  
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
  class root.Pitch
  
    constructor: (pitchClass, octave) ->
      
      if typeof octave is 'number'
        @octave = octave
        @pitchClass = new root.PitchClass(pitchClass)

      else if typeof pitchClass == "number"
        @octave = Math.floor(pitchClass / 12) - 5
        @pitchClass = new root.PitchClass(pitchClass % 12)

      else if typeof pitchClass is "string"

        # if unaltered pitch
        if pitchClass.length == 1
          @octave = 0
          @pitchClass = new root.PitchClass(pitchClass) 

        else if pitchClass.length == 2
          # if unaltered pitch and octave
          if typeof +pitchClass[1] is "number"
            @octave = +pitchClass[1]
            @pitchClass = new root.PitchClass pitchClass[0]

        else if pitchClass.length == 3
          #if unaltered pitch and negative octave
          if pitchClass[1] is "-" and typeof +pitchClass[2] is "number" 
            @pitchClass = new root.PitchClass pitchClass[0]
            @octave= +pitchClass[2] * -1
          #if altered pitch and positive octave
          else
            @pitchClass = new root.PitchClass pitchClass[0..1]
            @octave = +pitchClass[2]

        else if pitchClass.length == 4
          #altered pitch and negative octave
          @pitchClass = new root.PitchClass pitchClass[0..1]
          @octave = +pitchClass[3] * -1

        else
          return "sorry, wrong arguments"  

      @name = @pitchClass.name + @octave     
      @value = @pitchClass.int + ( @octave + 5 ) * 12

    dist_to: (other_pitch) ->
      return @value - other_pitch.value  



  #########################################################################
  class root.Note 
    constructor: (pitch, vel = 60 , duration, position) ->
      @pitch = new root.Pitch pitch
      @velocity = vel
      @duration = duration || new RVal 1
      @position = position || new Position()
  
  #########################################################################
  # return root
  
  # #console.log "hello"
  # p = new Note(75, rat(2,3))
  # puts p         


