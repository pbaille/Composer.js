window.addEventListener('load', function() {
	navigator.requestMIDIAccess( {sysex: false}).then( onMIDIInit, onMIDIFail );
} );

var selectMIDIIn = null;
var selectMIDIOut = null;
var midiAccess = null;
var midiIn = null;
var midiOut = null;
var launchpadFound = false;

function changeMIDIIn( ev ) {
  var list=midiAccess.inputs();
  var selectedIndex = ev.target.selectedIndex;

  if (list.length >= selectedIndex) {
    midiIn = list[selectedIndex];
    midiIn.onmidimessage = midiMessageReceived;
  }
}

function changeMIDIOut( ev ) {
  var list=midiAccess.outputs();
  var selectedIndex = ev.target.selectedIndex;

  if (list.length >= selectedIndex) {
    midiOut = list[selectedIndex];
  }
}

function onMIDIFail( err ) {
	alert("MIDI initialization failed.");
}

function onMIDIInit( midi ) {
  // var preferredIndex = 0;
  console.log("midi init")
  console.log(midi)
  midiAccess = midi;
  selectMIDIIn=document.getElementById("midiIn");
  selectMIDIOut=document.getElementById("midiOut");

  var list=midiAccess.inputs();

  // clear the MIDI input select
  selectMIDIIn.options.length = 0;

  if (list.length) {
    for (var i=0; i<list.length; i++)
      selectMIDIIn.options[i]=new Option(list[i].name,list[i].fingerprint);

    midiIn = list[0];
    midiIn.onmidimessage = midiProc;

    selectMIDIIn.onchange = changeMIDIIn;
  }

  // clear the MIDI output select
  selectMIDIOut.options.length = 0;
  preferredIndex = 0;
  list=midi.outputs();

  if (list.length) {
    for (var i=0; i<list.length; i++)
      selectMIDIOut.options[i]=new Option(list[i].name,list[i].fingerprint);

    midiOut = list[0];
    console.log(midiOut);
    selectMIDIOut.onchange = changeMIDIOut;
  }
}

// for input
function midiProc(event) {
  data = event.data;
  var cmd = data[0] >> 4;
  var channel = data[0] & 0xf;
  var noteNumber = data[1];
  var velocity = data[2];

  if ( cmd==8 || ((cmd==9)&&(velocity==0)) ) { // with MIDI, note on with velocity zero is the same as note off
    // note off
    //noteOff(b);
  } else if (cmd == 9) {  // Note on
    if ((noteNumber&0x0f)==8)
      tick();
    else {
      var x = noteNumber & 0x0f;
      var y = (noteNumber & 0xf0) >> 4;
      flipXY( x, y );
    }
  } else if (cmd == 11) { // Continuous Controller message
    switch (b) {
    }
  }
}
