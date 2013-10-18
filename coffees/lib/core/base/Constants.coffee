define ["lib/utils/Rational","lib/Utils/Array_adds", "vendors/ruby", "vendors/underscore"], ->
  
  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core  

  MK = root.MK = {}

  # RATIONAL shortcut
  rat = (args...) ->
    new AC.Utils.Rational args...   

  MK.MIDI_NOTES= do ->
    midi_notes = []
    for i in [-5..5]
      for x,index in ["C ","Db ","D ","Eb ","E ","F ","Gb ","G ","Ab ","A ","Bb ","B "]
        midi_notes.push [x+i.toString(),(i+5)*12+index]
    midi_notes 	

  MK.PITCHES= 
    "C": 0
    #"C#": 1
    "Db": 1
    "D": 2
    #"D#": 3
    "Eb": 3
    "E": 4
    #"Fb": 4
    #"E#": 5
    "F": 5
    #"F#": 6
    "Gb": 6
    "G": 7
    #"G#": 8
    "Ab": 8
    "A": 9
    #"A#": 10
    "Bb": 10
    "B": 11
    #"Cb": 11
    #"B#": 0

  MK.DURATIONS=  
    w:  rat(1)
    h:  rat(1,2)
    q:  rat(1,4)
    e:  rat(1,8)
    s:  rat(1,16)
    t:  rat(1,32)
    

  MK.MOTHERS=
    "Lyd":
      functs: [0,2,4,6,7,9,11]
      degrees:["Lyd","Mix", "Eol", "Loc", "Ion", "Dor", "Phry"]
      modes_prio:[
        [6,11,4,9,2,7]
        [10,5,4,9,2,7]
        [8,2,7,3,10,5]
        [6,1,10,8,3,5]
        [11,5,4,9,2,7]
        [9,3,10,2,7,5]
        [1,7,5,10,3,8]
      ]  

    "Lyd+" : 
      functs: [0,2,4,6,8,9,11]
      degrees: ["Lyd+","Lydb7", "Mixb6", "Loc2", "Alt", "Melm", "Phry6"]
      modes_prio:[
        [8,11,4,6,9,2]
        [6,10,4,9,2,7]
        [8,4,2,7,5,10]
        [6,2,3,10,5,8]
        [4,10,8,3,6,1]
        [11,3,9,2,7,5]
        [9,1,5,10,3,7]
      ]

    "Lyd+9": 
      functs: [0,3,4,6,7,9,11]
      degrees: ["Lyd+9","AltDim", "Harmm", "Loc6", "Ion+", "Dor#4", "PhryM"]
      modes_prio:[
        [6,3,11,4,9,2]
        [4,9,1,6,8,3 ]
        [8,11,2,3,7,5]
        [6,9,1,10,3,5]
        [5,8,11,3,2,9]
        [9,6,3,2,10,7]
        [1,4,7,10,8,5]
      ]

  MK.MOTHER_STEPS=
    "Lyd"  :[2,2,2,1,2,2,1]
    "Lyd+" :[2,2,2,2,1,2,1]
    "Lyd+9":[3,1,2,1,2,2,1]

  MK.MODAL_MOVES=
    "SD"   : 5
    "SD-"  : 8
    "SD+"  : 2
    "SDalt": 11
    "T"    : 0
    "T-"   : 3
    "T+"   : 9
    "Talt" : 6

  MK.PASSING_FUNCTIONS= ["sd","dd+","dd","cd","cu","du","du+","su"]  

  MK.DEGREES_NAMES= [
    {0: "R"}
    {1: "m2", 2: "M2", 3: "#2"}
    {2: "o3", 3: "m3", 4: "M3", 5: "#3"}
    {4: "b4", 5: "P4", 6: "+4"}
    {6: "b5", 7: "P5", 8: "+5"}
    {8: "m6", 9: "M6", 10: "+6"}
    {9: "o7", 10: "m7", 11: "M7"}
  ]  
   

  MK.ABSTRACT_DEGREES= ["root", "second", "third", "fourth", "fifth", "sixt", "seventh"]

  MK.childs= (m) ->
    result = {}
    mot = MK.MOTHERS[m]
    if mot
      temp = _.zip(mot.degrees, _a.tonicized_rotations(mot.functs))
      for x in temp
        result[x[0]] = x[1]
      return result	
    else null
    
  MK.all_modes = do ->
    modes= {}
    for k,v of MK.MOTHERS
      for kk,vv of MK.childs(k)
      	modes[kk] = vv
    modes

  

  "mk_loaded"  

 #    def MK.regular_mothers
 #    	reg_moths={}
 #    	MOTHERS.each do |k,v| 
	# 	    case k
	# 	    when "Lyd"
	# 	    	reg_moths["Major"]={:funct => v[:functs].rotate(4).tonicize,
	# 	    							  :degrees => v[:degrees].rotate(4),
	# 	    							  :modes_prio => v[:modes_prio].rotate(4)}
	# 	    when "Lyd+"
	# 	    	reg_moths["Melodic Minor"]={:funct => v[:functs].rotate(5).tonicize,
	# 	    							  :degrees => v[:degrees].rotate(5),
	# 	    							  :modes_prio => v[:modes_prio].rotate(5)}
	# 	    when "Lyd+9"
	# 	    	reg_moths["Harmonic Minor"]={:funct => v[:functs].rotate(2).tonicize,
	# 	    							  :degrees => v[:degrees].rotate(2),
	# 	    							  :modes_prio => v[:modes_prio].rotate(2)}
	# 	    end							  							  							  
	# 	end
	# 	reg_moths	
 #    end
