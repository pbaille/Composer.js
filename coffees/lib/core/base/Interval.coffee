define ["lib/core/base/Note", "lib/core/base/Constants"], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  MK= AC.Core.MK
  Pitch = AC.Core.Pitch

  class root.Interval
    constructor: (args...) ->
      #args = (pitch1, pitch2)
      if args.length == 2
      	"pouet"

