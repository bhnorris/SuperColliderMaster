s.quit;
s.boot;

x = Synth.new(\clap);
y = Synth.new(\snaredrumfull);
z= Synth.new(\snaredrum);
o = Synth.new(\openhat);
c = Synth.new(\closedhat);
k = Synth.new(\fullkickdrum);
t = Synth.new(\kickdrum);

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/49752__aarongnp__gnp-bass-drum-namblam.wav");
~b1 = b;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/49747__aarongnp__gnp-bass-drum-drop-the-soap.wav");
~b2 = b;
l = Pbind(\instrument, \buffkik,\bufnum, ~b2.bufnum, \delta, 1,\amp, 0.2).play(quant: 1);
l.stop;
~b1.play;
~b2.play;
TempoClock.default.tempo = 132/60;

p = Pxrand([
    Pbind(
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 1, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.7, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.8, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.75, \detune, 1.005
    )
], inf).play(quant: 1);

k = Pbind(\instrument, \kik, \delta, 1, \preamp, 4.5, \amp, 0.32).play(quant: 1);
j = Pbind(\instrument, \clap, \delta, 1, \preamp, 4.5, \amp, 0.32).play(quant: [1,0.5]);
l = Pbind(\instrument, \buffkik,\bufnum, ~b1.bufnum, \delta, 1,\amp, 0.2).play(quant: 1);
p.stop;
j.stop;
k.stop;
l.stop;
{ LFPulse.ar(XLine.kr(50,250,6,doneAction: 2),0,0.5,0.75) }.scope(2, zoom: 1);
{ LFPulse.ar(XLine.kr(250,50,6,doneAction: 2),0,0.5,0.75) }.scope(2, zoom: 1);