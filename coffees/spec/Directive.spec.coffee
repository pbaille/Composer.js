define ["lib/core/index"] , ->

  Track = AC.Core.Track
  Position = AC.Core.Position
  RVal = AC.Core.RVal
  TimeLine = AC.Core.TimeLine
  Directive = AC.Core.Directive
  
  describe "Directive class" , ->
  	it "init" , ->
  	  expect(new Directive(
  	  	position: new Position
  	  	  cycle: 1
  	  	  bar: 0
  	  	  sub: new RVal 0
  	  	)).toBeTruthy()
  	  