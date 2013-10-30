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

#####################
console.clear()
    
require ["lib/core/index","lib/GUI/index","lib/midi/index","lib/utils/index","jquery"], ()->

  window.rat = (n,d) ->
    new AC.Utils.Rational(n,d)

  jQuery ($) ->


    RGen = AC.Core.RGen
    TimeLine = AC.Core.TimeLine
    RVal = AC.Core.RVal
    Note = AC.Core.Note
    Mode = AC.Core.Mode
    Bar = AC.Core.Bar
    Track = AC.Core.Track
    Directive = AC.Core.Directive
    Position = AC.Core.Position
  
    window.timeline = new TimeLine
      cycle: true


    bar = new Bar 
      beats: 4
      beat_val: new RVal 1
      bpm: 120
      resolution: new RVal 1,4

    timeline.insert_bar bar,0,2 #insert 4 * bar at index 0

    # timeline.grid = [
    #   new Bar 
    #     beats: 4
    #     beat_val: new RVal 1
    #     bpm: 60
    #     resolution: new RVal 1,4
    #   new Bar 
    #     beats: 3
    #     beat_val: new RVal 1
    #     bpm: 60
    #     resolution: new RVal 1,4  
    # ]


    track1 = new Track
      midi_channel: 1
      directives: [ 

        new Directive
          position: new Position {cycle: 0, bar: 0, sub: new RVal 0}
          type: "rythmic"
          method_name: "set_prob_array"
          args:[ 
            [
              {rval: new RVal(1,2), occ: 1 }
              {rval: new RVal(1,4), occ: 1 }
              # {rval: new RVal(1,3), occ: 1 }
              {rval: new RVal(1,6), occ: 1 }

            ]
          ]

        #first bar (timeline.grid[0]) default to C Lyd
        new Directive
          position: new Position {cycle: 0, bar: 0, sub: new RVal 0}
          type: "harmonic"
          method_name: "abs_move"
          args: ["T",1] #SD mode 1st degree (ex: in C Lyd => F Lyd)

        # new Directive
        #   position: new Position {cycle: 0, bar: 0, sub: new RVal 1,16}
        #   type: "melodic"
        #   method_name: "set_degrees_functions"
        #   args: [{root: "disabled", second: "disabled", fifth:"disabled"}]

        new Directive
          position: new Position {cycle: 0, bar: 1, sub: new RVal 0}
          type: "harmonic"
          method_name: "abs_move"
          args: ["SD-",1] #SD mode 1st degree (ex: in C Lyd => F Lyd)

      ]

      # add hard coded notes (for bass)
      midi_events:
        notes:[
          new Note 48,100, new RVal(4), new Position({bar: 0})
          new Note 44,100, new RVal(4), new Position({bar: 1})
        ]

    timeline.tracks.push track1 





















  ### UI RT Version ###

  # window.rgen = new AC.Core.RGen
  #     streamLen: rat(2,1)

  #   window.rythmnValSel = new AC.GUI.RVS 
  #     el: "#rvs"
  #     table:
  #       # 2:1
  #       4:1
  #       10:1
  #       # 8:3
  #       # 3:1
  #       # 6:1
  #       #24:1
  #     generator: rgen

  #   window.maestro = new AC.Core.Metronome
  #     bpm: 100
  #     beats: 5
  #     unit: 4
  #     listeners: [rgen]
  #     on_click: ->
  #       $('#tempo').html("#{@bars + '>' + @count}")


    ##############################################################    
    ##############################################################
  
  
      