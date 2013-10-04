define ['lib/core/base/AbstractMode'], () ->  
  
  AbstractMode = AC.Core.AbstractMode

  describe "AbstractMode", ->

    it "initialize by name", ->
      am = new AbstractMode "Mix"
      #console.log am
      expect(am).toBeTruthy()
      am2 = new AbstractMode "Lyd+"
      #console.log am2
      expect(am2).toBeTruthy()

    it "initialize by mother name , degree " , ->
      am = new AbstractMode "Lyd", 3
      #console.log am
      expect(am.name).toEqual("Eol")  
      am2 = new AbstractMode "Lyd+", 7
      #console.log am2
      expect(am2.name).toEqual("Phry6")  

    it "initialize by functs " , ->
      am = new AbstractMode [0,1,3,4,6,8,10]
      #console.log am
      expect(am.name).toEqual("Alt")
      am2 = new AbstractMode [0,2,3,5,7,9,10]
      #console.log am2
      expect(am2.name).toEqual("Dor")  
      am3 = new AbstractMode [0,1,3,5,7,9,11]
      #console.log am3
      expect(am3.name).toEqual("unknown")  