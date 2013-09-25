define ["lib/core/RVal","lib/core/RGen","lib/core/MGen","lib/core/HGen"], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core
  
  RVal = AC.Core.RVal
  RGen = AC.Core.RGen
  MGen = AC.Core.MGen
  HGen = AC.Core.HGen
  #DGen = AC.Core.DGen

  class root.Composer

    constructor: (opt) ->    
      #temp
      opt = {} unless opt

      @strategy = @set_strategy opt.strategy #global strategy (way that generators are used together etc...)

      @rgen = opt.rgen || new RGen #rythmic generator
      @mgen = opt.mgen || new MGen  #melodic generator
      @hgen = opt.hgen || new HGen  #harmonic generator
      #@dgen = opt.dgen || new DGen  #dynamic generator

      #reference composer in each generator (cyclic ref...)
      @rgen.composer = @mgen.composer = @hgen.composer = @ #@dgen.composer = @ 

      @ahead = new RVal 0
      @advance = opt.advance || new RVal 2 #default advance of 2 beats

    head_position: ->
      timeline.position.plus @ahead  

    apply_directive: (d) -> #directive objet
      switch d.type
        when "rythmic"  then @rgen[d.method_name](d.args...)  
        when "melodic"  then @mgen[d.method_name](d.args...)  
        when "harmonic" 
          @hgen[d.method_name](d.args...) 
          @mgen.set_mode(@hgen.current) #update mgen mode 

        #when "dynamic"  then @dgen[d.method_name](d.args...)  

    tic: ->
      # temp # call #generate on each generator , when @strategy will be implemented, 
      # the order of called generators should change depending on it , 
      # and other directives should be send to generators
      if @ahead.lt @advance
        @strategy()

      @ahead.subtract timeline.resolution 

    set_strategy: (strat_name = "default") ->  
      if strat_name is "default"
      	return =>
      	  rythmn_line = @rgen.generate()
      	  @mgen.melodize(rythmn_line)











