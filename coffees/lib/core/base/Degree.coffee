define ["lib/core/base/Constants"], () ->
  
  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core  

  MK = root.MK 

  class root.Degree

    @NAME_DIST_MAP= {"m2":1,"M2":2,"#2":3,"o3":2,"m3":3,"M3":4,"#3":5,"b4":4,"P4":5,"+4":6,"b5":6,"P5":7,"+5":8,"m6":8,"M6":9,"#6":10,"o7":9,"m7":10,"M7":11}
    @DEFAULTS= {"root" : "R ", "second" : "M2", "third" : "M3", "fourth" : "P4", "fifth" : "P5", "sixt" : "M6", "seventh" : "M7"}
    @ALTERATIONS=
      root: 
        {0 : "R"}
      second : 
        {1 : "m2", 2 : "M2", 3 : "#2"}
      third  : 
        {2 : "o3", 3 : "m3", 4 : "M3", 5 : "#3"}
      fourth : 
        {4 : "b4", 5 : "P4", 6 : "+4"}
      fifth  : 
        {6 : "b5", 7 : "P5", 8 : "+5"}
      sixt   : 
        {8 : "m6", 9 : "M6", 10 : "#6"}
      seventh: 
        {9 : "o7", 10 : "m7", 11 : "M7"}

    constructor: (args...) ->

      test = Number args[0][1]
      
      unless test  # args[0] is a generic_name (NaN is falsy)
        @generic_name= args[0]
        if args.length == 2 # generic name + dist
          @name= root.Degree.ALTERATIONS[args[0]][args[1]]
        else
          @name = root.Degree.DEFAULTS[args[0]] 

      else # args[0] is a name
        @name = args[0]
        @generic_name= MK.ABSTRACT_DEGREES[Number(args[0][1]) - 1]

      @dist= root.Degree.NAME_DIST_MAP[@name]


    alt: (modifier) ->
      current_index= Degree.alt_map()[@generic_name].indexOf(@name)
      if new_name= Degree.alt_map()[@generic_name][current_index + modifier]
        return new Degree new_name
      else
        return undefined

    @alt_map: ->
      dam= {}
      for k,v of root.Degree.NAME_DIST_MAP
        index = Number(k[1]) - 1
        dam[MK.ABSTRACT_DEGREES[index]] = [] unless dam[MK.ABSTRACT_DEGREES[index]]
        dam[MK.ABSTRACT_DEGREES[index]].push k
      dam



