define ["lib/core/Mode"], () ->
  
  Mode = AC.Core.Mode
  AbstractMode = AC.Core.AbstractMode

  describe "Mode class", () ->

    describe "constructor" , () ->

      window.m1 = {}
      window.m2 = {}
      window.m3 = {}
      window.m4 = {}

      it "with name string", () ->
        window.m1 = new Mode "D Lyd+"
        expect(m1).toBeTruthy()

      it "with concrete array", () ->
        window.m2 = new Mode [2,4,6,8,10,11,1]
        expect(m2).toEqual(m1)

      it "with abstract and root", () ->
        window.m3 = new Mode 
          abstract: new AbstractMode("Lyd+")
          root: "D"
        expect(m3).toEqual(m1)
      it "with mother and degree", () ->
        window.m4 = new Mode
          mother: "D Lyd+" 
          degree: 1
        expect(m4).toEqual(m1)

    describe "setters", () ->

      it "set_root", () ->
        window.m1 = new Mode "E Lyd+"
        window.m2.set_root("E")
        expect(m2).toEqual(m1)

      it "set_abstract", () ->
        window.m1 = new Mode "E Dor"
        window.m2.set_abstract [0,2,3,5,7,9,10]
        expect(m2).toEqual(m1)

      it "set_concrete", () ->
        window.m1 = new Mode "A Dor"
        window.m2.set_concrete [9,11,0,2,4,6,7]
        expect(m2).toEqual(m1) 

      it "set_name", () ->
        window.m1 = new Mode "E Dor"
        window.m2.set_name "E Dor"
        expect(m2).toEqual(m1)

      it "set_mother", () ->
        window.m1 = new Mode "E Melm"
        window.m2.set_mother "Lyd+"
        expect(m2).toEqual(m1)

    describe "harmonic motions" , () ->

      it "transpose", () ->
        window.m1 = new Mode "E Melm"
        window.m2 = new Mode "G Melm"
        window.m1.transpose 3
        expect(m2).toEqual(m1)

      it "intra_rel_move", () ->
        window.m1 = new Mode "E Melm"
        window.m2 = new Mode "G Lyd+"
        window.m1.intra_rel_move 2
        expect(m2).toEqual(m1)

      it "intra_abs_move", () ->
        window.m1 = new Mode "E Melm"
        window.m2 = new Mode "G Lyd+"
        window.m2.intra_abs_move 6
        expect(m2).toEqual(m1)  

      it "relative", () ->
        window.m1 = new Mode "E Melm"
        window.m2 = new Mode "G Lyd+"
        window.m2.relative "Melm"
        expect(m2).toEqual(m1)  
            



