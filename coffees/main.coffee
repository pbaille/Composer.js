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
        {rval: new RVal(1,2), occ: 1}
        # {rval: new RVal(3,8), occ: 3}
        {rval: new RVal(1,3), occ: 1}
        {rval: new RVal(1,6), occ: 1}
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
        # new Bar
        #   beats: 4
        #   beat_val: new RVal 1
        #   bpm: 60
        #   resolution: new RVal 1,4
        #   harmonic_directives: [
        #     {at: new RVal(0), mode: new Mode("B Lyd")}
        #     {at: new RVal(2), mode: new Mode("Ab Lyd")}
        #   ]
      ]
      cycle: true
      rgen: rgen2    

    



  # window.MM = my_midi

  # rgh = [
  #   {value: rat(1,2), occ: 1}
  #   {value: rat(1,4), occ: 1}
  #   {value: rat(3,8), occ: 3}
  #   {value: rat(1,3), occ: 1}
  #   {value: rat(1,6), occ: 1}
  # ]

  # rg = new RGen(rgh)
  
  # rvals = rg.next(20)

  # window.line = []
  # for x in [0..20]
  #   pitch = Math.floor(Math.random()*30 + 40)
  #   vel = Math.floor(Math.random()*30 + 40)
  #   dur = rvals[x]

  #   line.push [new Note(pitch, vel, dur), new Note(pitch + 5, vel, dur)]

  # # my_midi.line
  # #   notes: line   
  
  # r = rat(4,2)
  # r.add(rat(1,3))
  # puts r

  # puts r
  # window.n = new Note(48, 60 , r)
  # puts n
  
  #console.log line  
  # my_midi.play
  #   note: n
  
  # rg.add [
  #   { value: rat(1,4),occ: 2}
  # ] 

  # a = rg.denoms()
  # console.log a

  # rg.remove(rat(1,2))
  # console.log rg

  # puts "rvs"
  # console.log RVS
  # #RVS = rvs.RVS
  
      