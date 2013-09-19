define ["lib/core/Bar","lib/core/Rval","lib/core/Mode","lib/core/TimeLine"], ->
  
  TimeLine = AC.Core.TimeLine
  Bar = AC.Core.Bar
  RVal = AC.Core.RVal
  Mode = AC.Core.Mode

  describe "TimeLine Class", ->
  	it "initialize", () ->
  	  window.tl= new TimeLine
  	    grid: [
  	      new Bar 
  	        beats: 4
  	        beat_val: new RVal 1
  	        bpm: 120
  	        resolution: new RVal 1,4
  	        harmonic_directives: [
  	          {at: new RVal(0), mode: new Mode("C Lyd")}
  	          {at: new RVal(2), mode: new Mode("Eb Lyd")}
  	        ]
  	      new Bar
  	        beats: 4
  	        beat_val: new RVal 1
  	        bpm: 60
  	        resolution: new RVal 1,4
  	        harmonic_directives: [
  	          {at: new RVal(0), mode: new Mode("B Lyd")}
  	          {at: new RVal(2), mode: new Mode("Ab Lyd")}
  	        ]
  	    ]
  	    cycle: true
  	  expect(tl).toBeTruthy()  
