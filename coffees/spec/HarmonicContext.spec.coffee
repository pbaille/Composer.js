define ["lib/core/HarmonicContext"], ->
  
  HarmonicContext = AC.Core.HarmonicContext
  Mode = AC.Core.Mode

  describe "HarmonicContext", ->
  	
    it "initialize without error", ->
      hc = new HarmonicContext "C Lyd"
      expect(hc).toBeTruthy()
      expect(hc.current).toEqual(new Mode "C Lyd")
      expect(hc.center).toEqual(new Mode "C Lyd")

    it "rel_move", ->
      hc = new HarmonicContext "C Lyd"
      hc.rel_move "SD"
      expect(hc.current).toEqual(new Mode "F Lyd")
      hc.rel_move "SD"
      expect(hc.current).toEqual(new Mode "Bb Lyd")

    it "abs_move", ->
      hc = new HarmonicContext "C Lyd"
      hc.abs_move "SD"
      expect(hc.current).toEqual(new Mode "F Lyd")
      hc.abs_move "SD-"
      expect(hc.current).toEqual(new Mode "Ab Lyd")

    it "centerize", ->
      hc = new HarmonicContext "C Lyd"
      hc.abs_move "SD"
      hc.centerize()
      expect(hc.center).toEqual(new Mode "F Lyd")
      hc.abs_move "SD"
      expect(hc.current).toEqual(new Mode "Bb Lyd")

    it "set_center", ->
      hc = new HarmonicContext "C Lyd"
      hc.set_center "Bb Alt"
      expect(hc.center).toEqual(new Mode "Bb Alt")

