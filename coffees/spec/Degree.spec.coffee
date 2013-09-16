define ['lib/core/Degree'], () ->  

  describe "Degree class", ->

    d = {}

    beforeEach ->
      d = new AC.Core.Degree "second", 1

    describe "constructor", ->
      it "name", ->
        expect(d.name).toBe("m2")
      it "generic_name", ->
        expect(d.generic_name).toBe("second")
      it "dist", ->
        expect(d.dist).toBe(1)
    it "alt method", ->
      d1 = d.alt(1)
      d2 = d.alt(2)
      expect(d1.dist).toBe(2)
      expect(d2.dist).toBe(3)
      expect(d2.name).toBe("#2")

