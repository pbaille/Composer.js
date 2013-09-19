define [], () ->

  if typeof global != "undefined" && global != null 
    root= global.AC.MIDI
  else
    root= window.AC.MIDI

  root.play = (opt) ->
    notes= opt.note || new Note "C 0", rat(2,3)
    channel= 143 + opt.channel || 144
    at= opt.at || 0

    unless notes.length
      notes = [notes]

    for n in notes

      midiOut.send([channel , n.pitch.value, n.velocity], at) #on
      midiOut.send([channel , n.pitch.value, 0], at + n.duration.toFloat() * 1000 - 1) #off ### -1ms to avoid cross on/off on repeated pitches
      
    "play_end"

  root.line = (opt) ->

  	channel= 143 + opt.channel || 144
  	at= opt.at || 0

  	time_position = 0

  	#console.log opt.notes
  	for n in opt.notes
  	  AC.MIDI.play 
  	    note: n 
  	    at: time_position + at

  	  if n.duration 
  	  	dur = n.duration.toFloat() 
  	  else	
  	  	dur = n[0].duration.toFloat() 

  	  time_position += dur * 1000  

  return root  

