define ['lib/core/Constants'], () ->  
  MK = AC.Core.MK
  describe "MK class", ->

    it "return all modes", ->
      console.log MK.all_modes
      expect(MK.all_modes["Alt"]).toEqual([0,1,3,4,6,8,10])