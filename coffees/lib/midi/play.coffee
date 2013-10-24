define ["lib/core/base/Note", "lib/utils/Rational"], () ->

  Note = AC.Core.Note
  Rational = AC.Utils.Rational

  if typeof global != "undefined" && global != null 
    root= global.AC.MIDI
  else
    root= window.AC.MIDI
  
  root.simple_play= (opt) ->
    pitch = opt.pitch
    vel = opt.velocity
    at = opt.at || window.performance.now() #default start to now
    duration = opt.duration || at + 1000 #default duration to 1s
  
    channel= 143 + opt.channel || 144
  
    midiOut.send([channel , pitch, vel], at) #on
    midiOut.send([channel , pitch, 0], at + duration) #off ### -1ms to avoid cross on/off on repeated pitches
      
    "simple_play_end" 
  
  # line => array of Note or [Note,Note,...](chord)
  root.play_line= (line, midi_chan = 1) ->  
  
    line = [line] unless line instanceof Array # if single note wrap it
  
    for n in line
      if n instanceof Note
        AC.MIDI.simple_play
          channel: midi_chan
          pitch: n.pitch.value
          velocity: n.velocity
          duration: n.position.rval_to_ms n.duration
          at: n.position.to_performance_time()
           
      #n must be a chord ([Note,Note,...])  
      else
        for cn in n
          AC.MIDI.simple_play
            channel: midi_chan
            pitch: cn.pitch.value
            velocity: cn.velocity
            duration: cn.position.rval_to_ms cn.duration
            at: cn.position.to_performance_time()
           
  root.all_off= (chan) ->
    channel = 143 + chan || 144
    for i in [0..127]
      midiOut.send [channel , i, 0], window.performance.now()
  
  return root      


