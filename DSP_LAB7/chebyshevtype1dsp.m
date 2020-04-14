function  [N,Pole,a,b]= chebyshevtype1dsp(Ap,As,Fp,Fs,method,Ts)
    n = acosh(sqrt(10^(0.1*As)-1)/sqrt(10^(0.1*Ap)-1))/acosh(Fs/Fp);
    N = ceil(n);
    epsilon = sqrt(10^(0.1*Ap)-1);
    k = 1:1:N;
    xk = (2*k-1)*pi/(2*N);
    y = asinh(1/epsilon)/N;
    Pole = 1i*Fp*(cos(xk)*cosh(y)+1i*sin(xk)*sinh(y));
    s = tf('s');
    chebyshev_poly=1;
    for i=1:N
        chebyshev_poly = (1-s/Pole(i))*chebyshev_poly;
    end
    G=1;
    if ~mod(N,2)
        G=1/(1+epsilon^2);
    end
    Ha = G/chebyshev_poly;
    display(Ha);
    pzmap(Ha);
    Hd = c2d(Ha,Ts,method);
    display(Hd);
    [b,a] = tfdata(Hd,'v');
    [Hd_mag,w]=freqz(b,a,2048);
    figure;
    hold on; grid on;
    plot(w/pi,20*log10(abs(Hd_mag)/max(abs(Hd_mag))),'r','LineWidth',1,'MarkerSize',5);
    title('Magnitude Response of Digital Filter');
    xlabel('Normalized Frequency(pi rad/sec)');
    ylabel('|H(jW)|dB');
    figure;hold on; grid on;
    [Hd_phase,w]=phasez(b,a,2048);
    plot(w/pi,180*Hd_phase/pi,'r','LineWidth',1,'MarkerSize',5);
    title('Phase Response of Digital Filter');
    xlabel('Normalized Frequency(pi rad/sec)');
    ylabel('<H(jW) (in deg)');
end