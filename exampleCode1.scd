(
    // select all the code and run it
    // use mouse to strum strings
{
	var pitch, mousex, out;
	pitch = [ 52, 59, 66, 67, 71, 81 ];
	mousex = MouseX.kr;
	out = Mix.arFill(pitch.size, { arg i;
		var pos, trigger1, trigger2, pluck1, pluck2, period, string1, string2,
		delay, mix;

		pos = 0.25 + (i * 0.1);
		period = pitch.at(i).midicps.reciprocal;

		trigger1 = HPZ1.kr(mousex > pos).abs;
		pluck1 = PinkNoise.ar(Decay.kr(trigger1, 0.05));
		string1 = CombL.ar(pluck1, period, period, 4);

		trigger2 = HPZ1.kr(mousex > (pos + 0.015)).abs;
		pluck2 = PinkNoise.ar(Decay.kr(trigger2, 0.05));
		string2 = CombL.ar(pluck2, period/2, period/2, 4);

		mix = Mix([string1, string2]);
		delay = CombN.ar(mix, 0.2, 0.2, 2);
		mix = Mix([mix, delay * 0.2]);

		Pan2.ar(FreeVerb.ar(delay, 0.5, 0.9, 0.4), i * 0.2 - 0.5);
	});
	LPF.ar(out, 12000);

	LeakDC.ar(out);


}.play;
)