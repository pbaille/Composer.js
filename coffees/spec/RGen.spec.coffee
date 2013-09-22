define ["lib/core/RGen","lib/core/RVal"], ->
  
  RGen2 = AC.Core.RGen2 
  RVal = AC.Core.RVal
  Rational = AC.Utils.Rational

  describe "RGen2 class", ->
  	it "initialize" , ->
  	  window.rg = new RGen2
  	    prob_array: [
  	      {rval: new RVal(1,2), occ: 1} #eight notes
  	      {rval: new RVal(1,4), occ: 2} #sixteenth notes
  	      {rval: new RVal(1,3), occ: 1} #triplet of eight
  	    ]
  	    advance: new Rational(1) #advance of one beat


  	  expect(rg).toBeTruthy()  

  	describe "available vals", ->
  	  it "with tl_pos at start", ->	
  	    rg.timeline.position= 
  	      cycle: 0
  	      bar: 0
  	      sub: new RVal 0
  
  	    expect(rg.available_vals()).toEqual([
  	      {rval: new RVal(1,2), occ: 1} #eight notes
  	      {rval: new RVal(1,4), occ: 2} #sixteenth notes
  	      {rval: new RVal(1,3), occ: 1} #triplet of eight
  	    ])

  	  it "with tl_pos at 1/2", ->	
  	    rg.timeline.position= 
  	      cycle: 0
  	      bar: 0
  	      sub: new RVal 1,2
  
  	    expect(rg.available_vals()).toEqual([
  	      {rval: new RVal(1,2), occ: 1} #eight notes
  	      {rval: new RVal(1,4), occ: 2} #sixteenth notes
  	    ])
  	      
  	  it "with tl_pos at 1/3", ->	
  	    rg.timeline.position= 
  	      cycle: 0
  	      bar: 0
  	      sub: new RVal 1,3
  
  	    expect(rg.available_vals()).toEqual([
  	      {rval: new RVal(1,3), occ: 1} #triplet of eight
  	    ])  

