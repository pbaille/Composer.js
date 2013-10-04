define ["lib/core/base/Domain"], ->
  
  Domain = AC.Core.Domain
  Mode = AC.Core.Mode

  describe "Domain class", ->
  	it "@pitches init", ->
  	  m = new Mode "C Lyd+"
  	  d = new Domain 
  	    mode: m
  	    bounds: [0,24]
  	    
  	  expect(d.pitches_values()).toEqual([0,2,4,6,8,9,11,12,14,16,18,20,21,23,24])