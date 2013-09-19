define ["lib/core/Constants", "lib/utils/Array_adds"], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  MK= root.MK

  class root.AbstractMode

    constructor: (args...) ->
      if args.length==1
        if typeof args[0] == "string" then @new_by_name(args[0]) else @new_by_functs(args[0])
      else @new_by_mother args[0],args[1]

    @Abs_moth= (name,functs) ->
      {name: name, functs: functs}

    new_by_name: (s) ->

      for k,v of MK.MOTHERS
        if v.degrees.indexOf(s) >= 0
          @name=s
          @degree= v.degrees.indexOf(s) + 1
          @functs=@childs(k)[@degree-1]
          @mother=AbstractMode.Abs_moth(k,v.functs)
          @prio=v.modes_prio[@degree-1] 


    new_by_mother: (m, d=1) ->
      mot = MK.MOTHERS[m]
      @name= mot.degrees[d-1]
      @functs= _a.tonicize(_a.rotate(mot.functs,d-1))
      @prio= mot.modes_prio[d-1]
      @mother= AbstractMode.Abs_moth(m,mot.functs)
      @degree= d

    new_by_functs: (a) ->
      for k,v of MK.all_modes
        if _.uniq(a.concat(v)).length == v.length
          @new_by_name(k)
          break

      #if unknown mode
      unless @name
        @name= "unknown"
        @functs= a
        @prio= a.slice(1,a.length)
        @mother= AbstractMode.Abs_moth("unknown",a)
        @degree= 1	


    childs: (m) ->
      _a.tonicized_rotations(MK.MOTHERS[m].functs)
      

    moth_offset: () ->  
      unless @is_mother()
      	@mother.functs[@degree-1] 
      else 0

    is_mother: () ->
      @name == @mother.name and @functs == @mother.functs

    degrees_names: () ->
      hash = {}
      for x,i in @functs
        hash[x] = MK.DEGREES_NAMES[i][x]
      hash
