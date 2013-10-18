define ["lib/core/base/Degree"], ->

  describe "Degree class", ->
    d = {}
    beforeEach ->
      d = new AC.Core.Degree("second", 1)

    describe "constructor", ->
      it "name", ->
        expect(d.name).toBe "m2"

      it "generic_name", ->
        expect(d.generic_name).toBe "second"

      it "dist", ->
        expect(d.dist).toBe 1


    it "alt method", ->
      d1 = d.alt(1)
      d2 = d.alt(2)
      expect(d1.dist).toBe 2
      expect(d2.dist).toBe 3
      expect(d2.name).toBe "#2"

    it "test_equality", ->
      other = new AC.Core.Degree "m2"
      expect(d.eq other).toBe true
        

    it "dist_up_to", -> 
      other = new AC.Core.Degree "m3"
      expect(d.dist_up_to other).toEqual 2

    it "dist_down_to", -> 
      other = new AC.Core.Degree "m3"
      expect(d.dist_down_to other).toEqual 10   