define ["lib/core/index"], ->
  
  TimeLine = AC.Core.TimeLine
  Bar = AC.Core.Bar
  RVal = AC.Core.RVal
  Mode = AC.Core.Mode
  Position = AC.Core.Position
  RGen = AC.Core.RGen
  Track = AC.Core.Track
  Directive = AC.Core.Directive

  init_tl = ->

    window.timeline = new TimeLine
      cycle: true

    bar = new Bar 
      beats: 4
      beat_val: new RVal 1
      bpm: 60
      resolution: new RVal 1,4

    timeline.insert_bar bar,0,2 #insert 2 * bar at index 0

    track1 = new Track
      midi_channel: 1
      directives: [ 

        new Directive
          position: new Position {cycle: 0, bar: 0, sub: new RVal 0}
          type: "rythmic"
          method_name: "set_prob_array"
          args:[ 
            [ {rval: new RVal(1,6), occ: 1 }
              {rval: new RVal(1,8), occ: 1 }
            ]
          ]

        #first bar (timeline.grid[0]) default to C Lyd
        new Directive
          position: new Position {cycle: 0, bar: 0, sub: new RVal 0}
          type: "harmonic"
          method_name: "abs_move"
          args: ["T",1] #SD mode 1st degree (ex: in C Lyd => F Lyd)

        new Directive
          position: new Position {cycle: 0, bar: 1, sub: new RVal 0}
          type: "harmonic"
          method_name: "abs_move"
          args: ["SD-",1] #SD mode 1st degree (ex: in C Lyd => F Lyd)
      ]

    timeline.tracks.push track1 

  init_tl()    