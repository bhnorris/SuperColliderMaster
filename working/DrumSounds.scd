s.quit;
s.boot;
(
SynthDef.new(\kickdrum, {|freq=60,out=0|

var osc, env;

osc = SinOsc.ar(freq);
env = Line.ar(1, 0, 1, doneAction: 2);



Out.ar(out,
    Pan2.ar(osc*env, 0)
)

}).send(s);

)

t = Synth(\kickdrum);

 ( SynthDef.new(\fullkickdrum, {

    var subosc, subenv, suboutput, clickosc, clickenv, clickoutput;

    subosc = {SinOsc.ar(60)};
    subenv = {Line.ar(1, 0, 1, doneAction: 2)};

    clickosc = {LPF.ar(WhiteNoise.ar(1),1500)};
    clickenv = {Line.ar(1, 0, 0.02)};

    suboutput = (subosc * subenv);
    clickoutput = (clickosc * clickenv);

    Out.ar(0,
        Pan2.ar(suboutput + clickoutput, 0)
    )

}).send(s);
)

k = Synth(\fullkickdrum);
t = Synth(\kickdrum);

( SynthDef.new(\openhat, {

var hatosc, hatenv, hatnoise, hatoutput;

hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};

hatosc = {HPF.ar(hatnoise,2000)};
hatenv = {Line.ar(1, 0, 0.3)};

hatoutput = (hatosc * hatenv);

Out.ar(0,
Pan2.ar(hatoutput, 0)
)

}).send(s);
)
(
SynthDef.new(\closedhat, {

var hatosc, hatenv, hatnoise, hatoutput;

hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};

hatosc = {HPF.ar(hatnoise,2000)};
hatenv = {Line.ar(1, 0, 0.1)};

hatoutput = (hatosc * hatenv);

Out.ar(0,
Pan2.ar(hatoutput, 0)
)

}).send(s); )

o = Synth(\openhat);
c = Synth(\closedhat);
k = Synth(\fullkickdrum);
t = Synth(\kickdrum);

(
SynthDef.new(\snaredrum, {

var drumosc, filterenv, drumoutput, volenv;

filterenv = {Line.ar(1, 0, 0.2, doneAction: 0)};
volenv = {Line.ar(1, 0, 0.6, doneAction: 2)};

drumosc = {Pulse.ar(100)};
drumoutput = {LPF.ar(drumosc,(filterenv *1000) + 30)};

Out.ar(0,
Pan2.ar(drumoutput * volenv, 0)
)

}).send(s);
)

t= Synth(\snaredrum);
o = Synth(\openhat);
c = Synth(\closedhat);
k = Synth(\fullkickdrum);
t = Synth(\kickdrum);

(
SynthDef.new(\snaredrumfull, {

var drumosc, filterenv, volenv, drumoutput, snaposc, snapenv, fulloutput;

drumosc = {Pulse.ar(100)};
filterenv = {Line.ar(1, 0, 0.2, doneAction: 0)};
volenv = {Line.ar(1, 0, 0.6, doneAction: 2)};
drumoutput = {LPF.ar(drumosc,(filterenv *1000) + 30)};

snaposc = {BPF.ar(HPF.ar(WhiteNoise.ar(1),500),1500)};
snapenv = {Line.ar(1, 0, 0.2, doneAction: 0)};

fulloutput = (drumoutput * volenv) + (snaposc * snapenv);


Out.ar(0,
Pan2.ar(fulloutput, 0)
)

}).send(s);
)

t = Synth(\snaredrumfull);
t= Synth(\snaredrum);
o = Synth(\openhat);
c = Synth(\closedhat);
k = Synth(\fullkickdrum);
t = Synth(\kickdrum);

(
SynthDef.new(\clap, {

var claposc, clapenv, clapnoise, clapoutput;

clapnoise = {BPF.ar(LPF.ar(WhiteNoise.ar(1),7500),1500)};
clapenv = {Line.ar(1, 0, 0.6, doneAction: 2)};

clapoutput = {Mix.arFill(7,
{arg i;
EnvGen.ar(
Env.new(
[0,0,1,0],
[0.01 * i,0,0.04]
)
) * clapnoise * 0.5
}
)};

Out.ar(0,
Pan2.ar(clapoutput * clapenv, 0)
)

}).send(s);
)

x = Synth.new(\clap);
y = Synth.new(\snaredrumfull);
z= Synth.new(\snaredrum);
o = Synth.new(\openhat);
c = Synth.new(\closedhat);
k = Synth.new(\fullkickdrum);
t = Synth.new(\kickdrum);


// read a soundfile


b = Buffer.read(s, Platform.resourceDir +/+ "sounds/49752__aarongnp__gnp-bass-drum-namblam.wav");
b.plot;
b.play;



		// now play it

		(

		x = SynthDef(\buffkik,{ arg out = 0, bufnum;

			Out.ar( out,

				PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum))

			)

		}).play(s,[\bufnum, b.bufnum ]);

		)
		x.free; b.free;
(
SynthDef(\bass, { |freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
    sig = LPF.ar(sig, ffreq);
    Out.ar(0, sig ! 2)
}).add;

TempoClock.default.tempo = 132/60;

p = Pxrand([
    Pbind(
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
], inf).play(quant: 1);
)

// totally cheesy, but who could resist?
(
SynthDef(\kik, { |preamp = 1, amp = 1|
    var    freq = EnvGen.kr(Env([400, 66], [0.08], -3)),
        sig = SinOsc.ar(freq, 0.5pi, preamp).distort * amp
            * EnvGen.kr(Env([0, 1, 0.8, 0], [0.01, 0.1, 0.2]), doneAction: 2);
    Out.ar(0, sig ! 2);
}).add;

SynthDef(\buffkik,{ arg out = 0, bufnum, amp = 1;

			Out.ar( out,

				PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum)) * amp

			)

		}).add;

// before you play:
// what do you anticipate '\delta, 1' will do?
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/49752__aarongnp__gnp-bass-drum-namblam.wav");
l = Pbind(\instrument, \buffkik,\bufnum, b.bufnum, \delta, 1,\amp, 0.2).play(quant: 1);
g = Pbind(\instrument, \clap, \delta, 1, \preamp, 4.5, \amp, 0.32).play(quant: 2);
)

p.stop;
l.stop;
g.stop;
