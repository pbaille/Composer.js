define ['lib/utils/Array_adds'], () ->  

  describe "Array adds", ->

    a = []

    beforeEach ->
      a = [1,2,3]

    it "rotate", ->
      expect(a.rotate(2)).toEqual([3,1,2])
    
    it "rotations", ->
      expect(a.rotations()).toEqual([[1,2,3],[2,3,1],[3,1,2]])

    it "somme", ->
      expect(a.somme()).toEqual(6)  

    it "median", ->
      expect(a.median()).toEqual(2)  
      expect([1,2].median()).toEqual(1.5)

    it "tonicize", ->
      expect(a.tonicize()).toEqual([0,1,2])  

    it "tonicized_rotations", ->
      expect(a.tonicized_rotations()).toEqual([[0,1,2],[0,1,11],[0,10,11]])  

      