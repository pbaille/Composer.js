define ["lib/core/base/Note", "lib/core/base/Interval"], ->

  Pitch = AC.Core.Pitch
  Interval = AC.Core.Interval

  describe "Interval class" , ->
    it "init" , ->
      i = new Interval "2m"
      expect(i).toBeTruthy()
