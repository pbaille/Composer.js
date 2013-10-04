define ["lib/utils/Combinatorics"], ->
  DomainPartition = AC.Utils.DomainPartition
  
  describe "DomainPartition class", ->
  	it "init", ->
  	  window.dp = new DomainPartition [-6..6], 10, 0
  	  expect(dp ).toBeTruthy()
