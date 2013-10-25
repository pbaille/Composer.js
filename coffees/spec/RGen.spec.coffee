define ["lib/core/composer/rythmn/RGen","lib/core/base/RVal","lib/core/structure/Position"], ->
  
  RGen = AC.Core.RGen 
  RVal = AC.Core.RVal
  Rational = AC.Utils.Rational
  Position = AC.Core.Position

  rg = {}
  
  describe "RGen class", ->
    it "initialize" , ->
      timeline.tracks[0].composer.rgen = new RGen
        prob_array: [
          {rval: new RVal(1,6), occ: 1} #eight notes
          {rval: new RVal(1,8), occ: 1} #sixteenth notes
        ]
      rg = timeline.tracks[0].composer.rgen
      rg.composer = timeline.tracks[0].composer 
      expect(rg).toBeTruthy()  

    describe "available vals", ->
      it "with tl_pos at start", ->	
        timeline.position= new Position
          cycle: 0
          bar: 0
          sub: new RVal 0
        
        expect(rg.available_vals()).toEqual([
          {rval: new RVal(1,6), occ: 1} #eight notes
          {rval: new RVal(1,8), occ: 1} #sixteenth notes
        ])

      it "with tl_pos at 1/2", ->	
        timeline.position= new Position
          cycle: 0
          bar: 0
          sub: new RVal 1,2
  
        expect(rg.available_vals()).toEqual([
          {rval: new RVal(1,6), occ: 1} #eight notes
          {rval: new RVal(1,8), occ: 1} #sixteenth notes
        ])
          
      it "with tl_pos at 1/3", ->	
        timeline.position= new Position
          cycle: 0
          bar: 0
          sub: new RVal 1,3
  
        expect(rg.available_vals()).toEqual([
          {rval: new RVal(1,6), occ: 1} #eight notes
        ])  

      it "rvals_allowed_permutations_at", ->
        timeline.tracks[0].composer.rgen = new RGen
          prob_array: [
            {rval: new RVal(1,2), occ: 1} 
            {rval: new RVal(1,4), occ: 1} 
            {rval: new RVal(1,3), occ: 1} 
            {rval: new RVal(1,6), occ: 1} 
          ]
        rg = timeline.tracks[0].composer.rgen
        aze = rg.rythmn_val_combinations(4, new RVal 1)
        console.log "aze[0] = " + aze[0]
        rapa = rg.rvals_allowed_permutations_at(aze[0], new Position({sub: new RVal(1,6)}))
        expect(rapa).toEqual([[new RVal(1,6),new RVal(1,6),new RVal(1,2),new RVal(1,6)]])
        rapa = rg.rvals_allowed_permutations_at(aze[0], new Position())
        expect(rapa).toEqual([
          [new RVal(1,2),new RVal(1,6),new RVal(1,6),new RVal(1,6)]
          [new RVal(1,6),new RVal(1,6),new RVal(1,6),new RVal(1,2)]
        ])





