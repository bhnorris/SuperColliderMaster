"Hello there, I'm SuperCollider!".postln;
"Hello World!".postln;
(
"Call me,".postln;
"Ishmael.".postln;
)
(
"Call me?".postln;
"Ishmael.".postln;
)
s.quit;
s.boot;
{[SinOsc.ar(440,0,0.2),SinOsc.ar(442,0,0.2)]}.play;
f={"Function evaluated".postln;};
f.value;
f={"Evaluating...".postln;2+3;};
f.value;
f = 3;            // Here I make f equal to a number
f.value;        // Post window says: 3, i.e it returns itself
f.value;        // Still says 3

f = { 3.0.rand; };    // Here it's a Function.
f.value;        // 3.0.rand means return a random value from 0 to 3.0 exclusive.
f.value;        // something different
f.value;        // something different
f = { arg a; a.value + 3 };    // call 'value' on the arg; polymorphism awaits!
f.value(3);            // 3.value = 3, so this returns 3 + 3 = 6
g = { 3.0.rand; };
f.value(g);            // here the arg is a Function. Cool, huh?
f.value(g);            // try it again, different result
(
f = { arg a, b;
    a - b;
};
f.value(5, 3);
)
f = { arg a, b; a / b; };    // '/' means divide
f.value(10, 2);            // regular style
f.value(b: 2, a: 10);        // keyword style
f = { arg a, b = 2; a + b; };
f.value(2);             // 2 + 2
f = { arg a, b; a + b; };
g = { |a, b| a + b; };
f.value(2, 2);
g.value(2, 2);
(
f = { arg a, b;
    var firstResult, finalResult;
    firstResult = a + b;
    finalResult = firstResult * 2;
    finalResult;
};
f.value(2, 3);    // this will return (2 + 3) * 2 = 10
)
(
var myFunc;
myFunc = { |input| input.postln; };
myFunc.value("foo");    // arg is a String
myFunc.value("bar");
)

myFunc;            // throws an error