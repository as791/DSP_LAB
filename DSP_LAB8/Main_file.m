clc;
clear;
close all;
%%  Load The Required Data %%

% Use any of the below three datas as EEG input according to the need.
% data = load('signal07_EEG.csv');
data = load('signal08_EEG.csv');
% data = load('signal09_eegalpha.csv');

%% Required Specifications for filter %%

% According to the given question the filter parameters calculated for the
% different wave filtering are given below. Please follow to the
% handwritten calculations done to find it. 
% To get desired output please put the below specifications for each cases.

% Specifications taken :- Ap = 1 dB, As = 40 dB, Ts = 0.005 sec
% 1. Delta :- Fp = 18.86 rad/s, Fs = 37.811 rad/s
% 2. Alpha :- Fpu = 74.44 rad/s, Fpl = 63.353 rad/s, Fsu = 96.03 rad/s,
% Fsl= 49.109 rad/s.
% 3. Gamma :- Fp = 219.90 rad/s, Fs = 195.96 rad/s

Ap = input('Pass Band Attenuation(in dB): ');
As = input('Stop Band Attenuation(in dB): ');
Ts = input('Sampling Time(s): ');

wave = input('Wave to extract:- Delta/Alpha/Gamma: ','s');

if wave == "Delta"
    Filter_type = "LPF";
elseif wave == "Alpha"
    Filter_type = "BPF"; 
elseif wave == "Gamma"
    Filter_type = "HPF";
end
if Filter_type == "LPF" || Filter_type == "HPF"
    Fp = input('Pass Band Edge Frequency(in rad/sec): ');
    Fs = input('Stop Band Edge Frequency(in rad/sec): ');
    F_b = [0,0,0,0];
    [N,Pole,a,b] = chebyshevtype1dsp(Ap,As,Fp,Fs,F_b,Filter_type,Ts);
else
    Fpu = input('Passband Upper Edge Frequecy (rad/sec): ');
    Fpl = input('Passband Lower Edge Frequecy (rad/sec): ');
    Fsu = input('Stopband Upper Edge Frequecy (rad/sec): ');
    Fsl = input('Stopband Lower Edge Frequecy (rad/sec): ');
    F_b = [Fpu,Fpl,Fsu,Fsl];
    [N,Pole,a,b] = chebyshevtype1dsp(Ap,As,0,0,F_b,Filter_type,Ts);
end

%% Required Filter and Filtered output %%

filtered_output = filter(real(b),real(a),data);

figure; hold on; grid on;
plot(data,'MarkerSize',5);
plot(filtered_output,'MarkerSize',5);
legend('EEG Signal','Filtered Signal');