define ["lib/core/index"], ->
  
  MGen = AC.Core.MGen
  
  init_mg = ->
  	new MGen()

  describe "MGen class", ->
  	it "initialize", ->
  	  expect(new MGen()).toBeTruthy