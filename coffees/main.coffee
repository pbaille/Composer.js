require.config
  paths:
    jquery: 'vendors/jquery-1.10.2.min'
    underscore: 'vendors/underscore'
    backbone: 'vendors/backbone'
  shim: 
    underscore: 
      exports: '_'
    backbone: 
      deps: ["underscore", "jquery"]
      exports: "Backbone"

window.AC = {}

window.AC.Core = {}
window.AC.MIDI = {}
window.AC.Utils = {}
window.AC.GUI = {}

    
require ["lib/core/index","lib/GUI/index","lib/midi/index","lib/utils/index","jquery"], ()->

  window.rat = (n,d) ->
    new AC.Utils.Rational(n,d)

  jQuery ($) ->

    window.rgen = new AC.Core.RGen
      streamLen: rat(2,1)

    window.rythmnValSel = new AC.GUI.RVS 
      el: "#rvs"
      table:
        # 2:1
        4:1
        10:1
        # 8:3
        # 3:1
        # 6:1
        #24:1
      generator: rgen

    window.maestro = new AC.Core.Metronome
      bpm: 100
      beats: 5
      unit: 4
      listeners: [rgen]
      on_click: ->
        $('#tempo').html("#{@bars + '>' + @count}")


    ##############################################################    
    ##############################################################

    RGen2 = AC.Core.RGen2
    TimeLine = AC.Core.TimeLine
    RVal = AC.Core.RVal
    Mode = AC.Core.Mode
    Bar = AC.Core.Bar

    window.rgen2 = new RGen2
      prob_array: [
        {rval: new RVal(1), occ: 1}
        # {rval: new RVal(1,2), occ: 1}
        # {rval: new RVal(3,8), occ: 3}
        # {rval: new RVal(1,3), occ: 1}
        # {rval: new RVal(1,6), occ: 1}
      ]
      advance: new RVal 2
  
  
    window.tl = new TimeLine
      grid: [
        new Bar 
          beats: 4
          beat_val: new RVal 1
          bpm: 60
          resolution: new RVal 1,4
          harmonic_directives: [
            {at: new RVal(0), mode: new Mode("C Lyd")}
            {at: new RVal(2), mode: new Mode("Eb Lyd")}
          ]
        new Bar
          beats: 4
          beat_val: new RVal 1
          bpm: 90
          resolution: new RVal 1,4
          harmonic_directives: [
            {at: new RVal(0), mode: new Mode("B Lyd")}
            {at: new RVal(2), mode: new Mode("Ab Lyd")}
          ]
      ]
      cycle: true
      rgen: rgen2    

  ##############################################################    
  ##############################################################

  #buggy need work !!!
  RubyJS.Array.prototype.unique_permutation = (block) ->
    #return _a.unique_permutation(arr) unless block

    array_copy = @sort()
    block array_copy.dup()
    return if @size() < 2

    while true
      # Based off of Algorithm L (Donald Knuth)
      j = @size() - 2

      j -= 1 while j > 0 and array_copy[j] >= array_copy[j+1]

      if array_copy[j] < array_copy[j+1]
        l = @size() - 1

        l -= 1 while array_copy[j] >= array_copy[l] 

        temp = array_copy[j]
        array_copy[j] = array_copy[l] 
        array_copy[l] = temp
        #array_copy[j+1..@size() -1] = array_copy[j+1..@size() -1].reverse()
        rev = array_copy.reverse()
        for e in [j+1..@size()-1]
          array_copy[e] = rev[e]

        block array_copy.dup()

      else
        break
  
      