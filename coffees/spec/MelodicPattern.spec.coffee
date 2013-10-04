define ["lib/core/composer/melody/MelodicPatternGen"], ->
  
  MelodicPattern = AC.Core.MelodicPattern
  MelodicPatternGen = AC.Core.MelodicPatternGen

  describe "MelodicPattern Class", ->
    it "initialize", ->
      window.mp = new MelodicPattern
        step_sequence: [1,1,1,-4]
        iterations: 3
      expect(mp).toBeTruthy()

    it "cycle_amplitude", ->
      expect(mp.cycle_amplitude()).toEqual([-1,3])
    
    it "cycle_step", ->
      expect(mp.cycle_step()).toEqual(-1)

    it "total_sequence", ->
      expect(mp.total_sequence()).toEqual([1,1,1,-4,1,1,1,-4,1,1,1,-4])

    it "next", ->
      seq = []
      seq.push mp.next() while seq[seq.length-1] != false
      expect(seq).toEqual([1,1,1,-4,1,1,1,-4,1,1,1,-4,false])

    it "length", ->
      expect(mp.length()).toEqual(12)  

  describe "MelodicPatternGen Class" , ->
    it "init", ->
      window.mpg = new MelodicPatternGen
        steps_array: [-2..2] 
        iterations: [2,3,4]
        cycle_step: [-2..2]
        pattern_length: [4,6]

      expect(mpg).toBeTruthy()

    it "patterns calc", ->
      expect(mpg.patterns.length).toEqual(118)

    it "give_pattern", ->
      expect(mpg.give_pattern() instanceof MelodicPattern).toBe(true)    

