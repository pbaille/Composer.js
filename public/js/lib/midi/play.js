// Generated by CoffeeScript 1.6.3
(function() {
  define([], function() {
    var root;
    if (typeof global !== "undefined" && global !== null) {
      root = global.AC.MIDI;
    } else {
      root = window.AC.MIDI;
    }
    root.play = function(opt) {
      var at, channel, n, notes, _i, _len;
      notes = opt.note || new Note("C 0", rat(2, 3));
      channel = 143 + opt.channel || 144;
      at = opt.at || 0;
      if (!notes.length) {
        notes = [notes];
      }
      for (_i = 0, _len = notes.length; _i < _len; _i++) {
        n = notes[_i];
        midiOut.send([channel, n.pitch.value, n.velocity], at);
        midiOut.send([channel, n.pitch.value, 0], at + n.duration.toFloat() * 1000);
      }
      return "play_end";
    };
    root.line = function(opt) {
      var at, channel, dur, n, time_position, _i, _len, _ref, _results;
      channel = 143 + opt.channel || 144;
      at = opt.at || 0;
      time_position = 0;
      _ref = opt.notes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        n = _ref[_i];
        AC.MIDI.play({
          note: n,
          at: time_position + at
        });
        if (n.duration) {
          dur = n.duration.toFloat();
        } else {
          dur = n[0].duration.toFloat();
        }
        _results.push(time_position += dur * 1000);
      }
      return _results;
    };
    return root;
  });

}).call(this);
