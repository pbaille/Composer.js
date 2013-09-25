define ["lib/core/index"] , ->

  Track = AC.Core.Track
  Position = AC.Core.Position
  TimeLine = AC.Core.TimeLine
  Composer = AC.Core.Composer
  
  describe "Composer class" , ->
  	it "init" , ->
  	  expect(new Composer
  	  	strategy: "kill them all"
  	  	).toBeTruthy()