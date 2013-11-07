define ['lib/utils/Rational','lib/core/base/Rval', 'vendors/ruby'], () ->  
  
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
      expect( new RVal(1,15).polyrythmic_base()).toBe(15)

    describe "binary_base", ->

      it "with binary val", ->
        expect(rv.binary_base()).toEqual(new Rational 1,2)  
  
      it "with polyrythmic val", ->
        rv = new RVal(1,10)
        expect(rv.binary_base()).toEqual(new Rational 1,2)

    describe "allowed_subs" , ->

      it "with binary val", ->
        expect(rv.allowed_subs()).toEqual([1,2])    
        
      it "with poly val", ->
        rv= new RVal 1,24
        expect(_a.sort(rv.allowed_subs())).toEqual(_a.sort([1,2,4,8,3,6,12,24]))    
