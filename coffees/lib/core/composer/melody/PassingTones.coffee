define ["lib/core/base/Constants"], ->
  
  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  MK = AC.Core.MK  
  
  class root.PassingSet
    constructor: (opt) ->
      @type_sequence = opt.type_sequence #Array of types ex : ["main_up","diat_down"]
      @target = opt.target #Pitch
      @start_on_target = opt.start_on_target || false # passing or broderie
      @profile = opt.profile
