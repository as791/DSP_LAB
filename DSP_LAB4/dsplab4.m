clc;
%---------------------------------- Import Data --------------------------%
%First we took imported the .csv file for ppg signal through import data
%method then we are using same code as in arduino ide.

%Visualizing the input given PPG Signal
figure(1);
plot(x);
xlabel('Sample Index(n)');
ylabel('X(n)');
title('Input PPG Signal');
%-------------------------------------------------------------------------%

n=size(x,2); %size of the data
Fs=25;    %sampling frequency
y=zeros(size(x)); %filtered X
m=8; %Moving average filter window size

%Moving Average Filter Operation
for i = 1:n
    for j = 1:m
        if i>=j
            y(i) = y(i)+x(i-j+1);
        end
    end
    y(i) = y(i)/m;
end
%Mean subtraction
avg = mean(y);
y = y - avg;

%Visualizing Filtered PPG Signal
figure(2);
plot(y);
xlabel('Sample Index(n)');
ylabel('Y(n)');
title('Filtered PPG Signal');

%------------------- Autocorrelation Method ------------------------------%
%Finding Autocorrelation
energy = 0;
for i=1:n
    energy = energy+y(i)*y(i);
end
autocorr = zeros(size(y));
for i = 1:n
    for j = 1:n
        if j>=i
            autocorr(i) = autocorr(i) + y(j)*y(j-i+1);
        end
    end
    autocorr(i) = autocorr(i)/energy;
end


%Visualizing Autocorrelation Function
figure(3);
plot(autocorr);
xlabel('Sample Index(n)');
ylabel('R(n)');
title('Autocorrelation Function');

%First Zero Crossing Point Implementation
fzcp = 0;
for i = 2:n-1
    if autocorr(i-1)>0 && autocorr(i+1)<0
        fzcp = i;
        break;
    end
end

%Finding the Lmax point to get periodic time of autocorrelation function
lmax=0;
peak=0;
for i = fzcp:n
    if peak<autocorr(i)
        peak = autocorr(i);
        lmax = i-1;
    end
end

%Pulse rate calculation
period_time = lmax/Fs;
pulse_rate = 60/period_time;

%------------------------ DFT Method -------------------------------------%

%Weights Matrix (Twidle Factor Matirx) Implementation 
weights = exp(-1i*2*pi*linspace(0,n-1,n)'*linspace(0,n-1,n)/n);

%DFT Matrix type based impementation
X = y*weights;
x_mag = abs(X); %Magnitude of DFT of x(n)

%As when we plot we see that Magnitude is symmetric so we will pick the
%first peak point of frequency from magnitude of X(k) 
kmax = 0;
peak = 0;
for i = 1:n/2
    if peak<x_mag(i)
        peak = x_mag(i);
        kmax = i;
    end
end
pulse_rate1 = 60*(kmax*Fs/n);

%Visualizing Magnitude of DFT[x(n)]
figure(4);
plot(x_mag);
xlabel('Sample Frequency(k)');
ylabel('|X(k)|');
title('Magnitude of DFT[x(n)]');

%Visualizing Phase of DFT[x(n)]
figure(5);
plot(angle(X));
xlabel('Sample Frequency(k)');
ylabel('<X(k)');
title('Phase of DFT[x(n)]');

%-------------------------------------------------------------------------%

%---------------------------- Final Output -------------------------------%
%Displaying value of the Pulse rate 
disp(['Pulse Rate of PPG Signal from Autocorrelation Method:- ',num2str(pulse_rate)]);
disp(['Pulse Rate of PPG Signal from DFT Method:- ', num2str(pulse_rate1)]);