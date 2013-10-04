define ["lib/core/index"], ->
  
  MGen = AC.Core.MGen
  Pitch = AC.Core.Pitch
  
  init_mg = ->
  	new MGen()

  describe "MGen class", ->
  	it "initialize", ->
  	  expect(new MGen()).toBeTruthy

  	it "set_current_pitch" , ->
  	  mg = new MGen
  	    bounds: [60,72]
  	  mg.set_current_pitch "C#1"
  	  expect(mg.current_pitch).toEqual(new Pitch "C1")
  	  expect(mg.current_index).toEqual(7)


