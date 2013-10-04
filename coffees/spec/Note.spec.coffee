define ["lib/core/base/Note", "lib/core/base/RVal", "lib/core/structure/Position"], ->
  
  MetaPitch = AC.Core.MetaPitch
  Alteration = AC.Core.Alteration
  PitchClass = AC.Core.PitchClass
  Pitch = AC.Core.Pitch
  Note= AC.Core.Note
  RVal = AC.Core.RVal
  Position = AC.Core.Position

  describe "MetaPitch class", ->
    it "init", ->
      n = new MetaPitch "C"
      expect(n.name).toEqual("C")
      n = new MetaPitch 2
      expect(n.name).toEqual("D")
  
  describe "Alteration class", ->
    it "init", ->
      n = new Alteration "b"
      expect(n.int).toEqual(-1)
      n = new Alteration 2
      expect(n.name).toEqual("x")
      n = new Alteration -1
      expect(n).toEqual(new Alteration "b")

  describe "PitchClass class", ->
    it "init", ->
      n = new PitchClass "C"
      expect(n.int).toEqual(0)
      n = new PitchClass 4
      expect(n.name).toEqual("E")
      n = new PitchClass 6
      expect(n.name).toEqual("Gb")
      expect(n.int).toEqual(6)

  describe "Pitch class", ->
    it "init", ->
      n = new Pitch "C0"
      expect(n.pitchClass.int).toEqual(0)
      expect(n.pitchClass.name).toEqual("C")
      expect(n.name).toEqual("C0")
      expect(n.value).toEqual(60)
      expect(n.octave).toEqual(0)

      expect(n).toEqual(new Pitch "C",0)
      expect(n).toEqual(new Pitch 60)
      expect(n).toEqual(new Pitch 0, 0)

      n = new Pitch "C-1"
      expect(n.pitchClass.int).toEqual(0)
      expect(n.pitchClass.name).toEqual("C")
      expect(n.name).toEqual("C-1")
      expect(n.value).toEqual(48)
      expect(n.octave).toEqual(-1)

      n = new Pitch "C#0"
      expect(n.pitchClass.int).toEqual(1)
      expect(n.pitchClass.name).toEqual("C#")
      expect(n.name).toEqual("C#0")
      expect(n.value).toEqual(61)
      expect(n.octave).toEqual(0)

      n = new Pitch "C#-2"
      expect(n.pitchClass.int).toEqual(1)
      expect(n.pitchClass.name).toEqual("C#")
      expect(n.name).toEqual("C#-2")
      expect(n.value).toEqual(37)
      expect(n.octave).toEqual(-2)

  describe "Note class" , ->
    it "init", ->
      n = new Note "C0"
      expect(n.pitch.pitchClass.int).toEqual(0)
      expect(n.pitch.pitchClass.name).toEqual("C")
      expect(n.pitch.name).toEqual("C0")
      expect(n.pitch.value).toEqual(60)
      expect(n.pitch.octave).toEqual(0)
      expect(n.duration).toEqual(new RVal 1)
      expect(n.velocity).toEqual(60)
      expect(n.position).toEqual(new Position())

      n = new Note "C#0", 45, new RVal(1,2)
      expect(n.pitch.pitchClass.int).toEqual(1)
      expect(n.pitch.pitchClass.name).toEqual("C#")
      expect(n.pitch.name).toEqual("C#0")
      expect(n.pitch.value).toEqual(61)
      expect(n.pitch.octave).toEqual(0)
      expect(n.duration).toEqual(new RVal 1,2)
      expect(n.velocity).toEqual(45)
      expect(n.position).toEqual(new Position())

      


      
          