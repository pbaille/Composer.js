define ['lib/utils/Rational','lib/core/Rval'], () ->  
  
  Rational= AC.Utils.Rational
  RVal = AC.Core.RVal

  describe "Rval class", ->

    rv = {}


    beforeEach ->
      rv = new RVal(1,2)

    it "to_ms", ->
      expect(rv.to_ms(120)).toEqual(250)
    
    it "polyrythmic_base", ->
      expect(rv.polyrythmic_base()).toBe(2)

    describe "binary_base", ->

      it "with binary val", ->
        expect(rv.binary_base()).toEqual(new Rational 1,2)  
  
      it "with polyrythmic val", ->
        rv = new RVal(1,10)
        expect(rv.binary_base()).toEqual(new Rational 1,2)
