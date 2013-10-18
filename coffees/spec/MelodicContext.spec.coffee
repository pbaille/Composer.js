define ["lib/core/base/MelodicContext"], ->
  
  MelodicContext = AC.Core.MelodicContext
  Mode = AC.Core.Mode

  describe "MelodicContext", ->
    it "initialize", ->

      window.mc1 = new MelodicContext 
        mode: new Mode("C Lyd")
        main_degrees: ["third", "fourth", "seventh"]
        disabled_degrees: ["root"]

      expect(mc1).toBeTruthy()

      window.mc2 = new MelodicContext 
        mode: new Mode("C Lyd")
        degrees_functions: 
          root: "main"
          third: "main"
          fourth: "main"
          sixth: "disabled"
          seventh: "main"

      expect(mc2).toBeTruthy()

      window.mc3 = new MelodicContext 
        mode: new Mode("C Lyd")
      expect(mc3).toBeTruthy()

      window.mc4 = new MelodicContext  "C Lyd"
      expect(mc4).toBeTruthy()