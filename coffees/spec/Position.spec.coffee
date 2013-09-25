define ["lib/core/index"] , ->
  
  TimeLine = AC.Core.TimeLine
  Bar = AC.Core.Bar
  RVal = AC.Core.RVal
  Mode = AC.Core.Mode
  Position = AC.Core.Position
  RGen = AC.Core.RGen

  describe "Position class" , ->
    it "plus", ->
      timeline.position = new Position
        cycle: 0
        bar: 0
        sub: new RVal 0
      expect(timeline.position.plus(new RVal 1,2)).toEqual new Position
        cycle: 0
        bar: 0
        sub: new RVal 1,2

      expect(timeline.position.plus(new RVal 5,1)).toEqual new Position
        cycle: 0
        bar: 1
        sub: new RVal 1

      expect(timeline.position.plus(new RVal 11,2)).toEqual new Position
        cycle: 0
        bar: 1
        sub: new RVal 3,2  

      expect(timeline.position.plus(new RVal 10)).toEqual new Position
        cycle: 1
        bar: 0
        sub: new RVal 2

      expect(timeline.position.plus(new RVal 4)).toEqual new Position
        cycle: 0
        bar: 1
        sub: new RVal 0  

      timeline.position = new Position
        cycle: 0
        bar: 0
        sub: new RVal 7,2

      console.log timeline.position.plus(new RVal 1,2)
      expect(timeline.position.plus(new RVal 1,2)).toEqual new Position
        cycle: 0
        bar: 1
        sub: new RVal 0 


    it "rval_to_ms", ->
      # setup grid with tempo changes
      timeline.grid = [
        new Bar
          beats: 4
          beat_val: new RVal 1
          bpm: 60
          resolution: new RVal 1,4
        new Bar
          beats: 4
          beat_val: new RVal 1
          bpm: 120
          resolution: new RVal 1,4  
      ]   
      # reset position to start 
      timeline.position = new Position
        cycle: 0
        bar: 0
        sub: new RVal 0 

      expect(timeline.position.rval_to_ms(new RVal 1,2)).toEqual 500
      expect(timeline.position.rval_to_ms(new RVal 9,2)).toEqual 4250
      expect(timeline.position.rval_to_ms(new RVal 21,2)).toEqual 8500

      timeline.position = new Position
        cycle: 1
        bar: 1
        sub: new RVal 7,2 

      expect(timeline.position.rval_to_ms(new RVal 1,2)).toEqual 250 


    it "test equality #eq", ->
      expect(timeline.position.eq(timeline.position)).toBe(true)

    it "test less or equal #le", ->
      temp = timeline.position.plus(new RVal 1)
      expect(timeline.position.le(temp)).toBe(true)
      temp = timeline.position.plus(new RVal 1)
      expect(temp.le(timeline.position)).toBe(false)
      expect(timeline.position.le(timeline.position)).toBe(true)

    it "test less than #lt", ->
      temp = timeline.position.plus(new RVal 1)
      expect(timeline.position.lt(temp)).toBe(true)
      temp = timeline.position.plus(new RVal 1)
      expect(temp.lt(timeline.position)).toBe(false)
      expect(timeline.position.lt(timeline.position)).toBe(false)  

    it "test greater than #gt", ->
      temp = timeline.position.plus(new RVal 1)
      expect(timeline.position.gt(temp)).toBe(false)
      temp = timeline.position.plus(new RVal 1)
      expect(temp.gt(timeline.position)).toBe(true)
      expect(timeline.position.gt(timeline.position)).toBe(false)  

    it "test greater or equal #lt", ->
      temp = timeline.position.plus(new RVal 1)
      expect(timeline.position.ge(temp)).toBe(false)
      temp = timeline.position.plus(new RVal 1)
      expect(temp.ge(timeline.position)).toBe(true)
      expect(timeline.position.ge(timeline.position)).toBe(true)    



