
define ["lib/utils/calcul"], ->
  
  Utils = AC.Utils

  describe "calcul module", ->
    it "gcd", ->
      expect(Utils.gcd(5,2)).toEqual(1)

    it "lcm", ->
      expect(Utils.lcm(5,2)).toEqual(10)

    it "lcmm", ->
      expect(Utils.lcmm([5,2,3])).toEqual(30)

