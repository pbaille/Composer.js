define ["lib/core/HGen"], ->
  
  HGen = AC.Core.HGen
  Mode = AC.Core.Mode

  describe "HGen", ->
  	
    it "initialize without error", ->
      hc = new HGen "C Lyd"
      expect(hc).toBeTruthy()
      expect(hc.current).toEqual(new Mode "C Lyd")
      expect(hc.center).toEqual(new Mode "C Lyd")

    it "rel_move", ->
      hc = new HGen "C Lyd"
      hc.rel_move "SD"
      expect(hc.current).toEqual(new Mode "F Lyd")
      hc.rel_move "SD"
      expect(hc.current).toEqual(new Mode "Bb Lyd")

    it "abs_move", ->
      hc = new HGen "C Lyd"
      hc.abs_move "SD"
      expect(hc.current).toEqual(new Mode "F Lyd")
      hc.abs_move "SD-"
      expect(hc.current).toEqual(new Mode "Ab Lyd")

    it "centerize", ->
      hc = new HGen "C Lyd"
      hc.abs_move "SD"
      hc.centerize()
      expect(hc.center).toEqual(new Mode "F Lyd")
      hc.abs_move "SD"
      expect(hc.current).toEqual(new Mode "Bb Lyd")

    it "set_center", ->
      hc = new HGen "C Lyd"
      hc.set_center "Bb Alt"
      expect(hc.center).toEqual(new Mode "Bb Alt")

