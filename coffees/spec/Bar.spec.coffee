define ["lib/core/Bar", "lib/core/RVal", "lib/core/Mode"], ->

  Bar = AC.Core.Bar
  RVal = AC.Core.RVal
  Mode = AC.Core.Mode

  describe "Bar class", ->

  	create_instance = ->
  	  b = new Bar
  	    beats: 4
  	    beat_val: new RVal 1
  	    bpm: 120
  	    resolution: new RVal 1,4
  	    harmonic_directives: [
  	      {at: new RVal(0), mode: new Mode("C Lyd")}
  	      {at: new RVal(2), mode: new Mode("Eb Lyd")}
  	    ]

  	it "initialize", ->
  	  window.b = create_instance()
  	  console.log b  
  	  expect(b).toBeTruthy()

  	it "duration", ->
  	  b = create_instance()
  	  expect(b.duration().eq(new RVal 4)).toBe(true)

  	it "ms_duration", ->
  	  b = create_instance()
  	  expect(b.ms_duration()).toEqual(2000)  

  	it "ms_duration_at", ->
  	  b = create_instance()
  	  expect(b.ms_duration_at(new RVal 2)).toEqual(1000)  

  	it "h_dir_at", ->
  	  b = create_instance()
  	  expect(b.h_dir_at(new RVal 3,4)).toEqual(new Mode "C Lyd")  
  	  expect(b.h_dir_at(new RVal 2)).toEqual(new Mode "Eb Lyd")  



