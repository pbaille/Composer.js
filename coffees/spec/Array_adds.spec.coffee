define ['vendors/ruby','lib/utils/Array_adds'], () ->  

  describe "Array adds", ->

    a = []

    beforeEach ->
      a = [1,2,3]

    it "wrap_if_not", ->
      expect(_a.wrap_if_not(5)).toEqual([5])  
      expect(_a.wrap_if_not(a)).toEqual([1,2,3]) 

    it "pick_random_el", ->
      expect(_a.pick_random_el(a)).toBeTruthy() 

    it "rotate", ->
      expect(_a.rotate(a,2)).toEqual([3,1,2])
    
    it "rotations", ->
      expect(_a.rotations(a)).toEqual([[1,2,3],[2,3,1],[3,1,2]])

    it "somme", ->
      expect(_a.somme(a)).toEqual(6)  

    it "median", ->
      expect(_a.median(a)).toEqual(2)  
      expect(_a.median([1,2])).toEqual(1.5)

    it "tonicize", ->
      expect(_a.tonicize(a)).toEqual([0,1,2])  

    it "tonicized_rotations", ->
      expect(_a.tonicized_rotations(a)).toEqual([[0,1,2],[0,1,11],[0,10,11]])  

      