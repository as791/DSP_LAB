clc;
clear;
close all;

Ap = input('Pass Band Attenuation(in dB): ');
As = input('Stop Band Attenuation(in dB): ');
Fp = input('Pass Band Frequency(in rad/sec): ');
Fs = input('Stop Band Frequency(in rad/sec): ');
Method = input('Method for transformation to digital filter:-Impulse-Invariant/Bilinear-Approximation: ','s');
Ts = input('Sampling Time(s): ');

if Method=="Impulse-Invariant"
    Method = 'impulse';
else
    Method = 'tustin';
end

Filter_type = input('Type of Filter:-Butterworth/Chebyshev Type-1: ','s');

if Filter_type=="Butterworth"
    [N,Pole,a,b] = butterdsp(Ap,As,Fp,Fs,Method,Ts);
else
    [N,Pole,a,b] = chebyshevtype1dsp(Ap,As,Fp,Fs,Method,Ts);
end