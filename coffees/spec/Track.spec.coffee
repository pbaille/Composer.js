define ["spec/init","lib/core/index"] , ->

  Track = AC.Core.Track
  Position = AC.Core.Position
  Directive = AC.Core.Directive
  RVal = AC.Core.RVal

  window.t = new Track
  	midi_channel: 1
  	directives: [
  	  new Directive
  	    position: new Position
  	    type: "rythmic"
  	    message: "message"

  	  new Directive
  	    position: new Position
  	      cycle: 0
  	      bar: 1
  	      sub: new RVal 1,2
  	      timeline: timeline
  	    type: "rythmic"
  	    message: "message2"

  	  new Directive
  	    position: new Position
  	      cycle: 1
  	      bar: 1
  	      sub: new RVal 0
  	      timeline: timeline
  	    type: "rythmic"
  	    message: "message3"    
  	]
  
  describe "Track class" , ->
  	it "init" , ->
  	  expect(t).toBeTruthy()

  	  
