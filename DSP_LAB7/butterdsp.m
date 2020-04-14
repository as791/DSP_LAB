function  [N,Pole,a,b]= butterdsp(Ap,As,Fp,Fs,method,Ts)
    n = (log(10^(0.1*Ap)-1) - log(10^(0.1*As)-1))/(2*log(Fp/Fs));
    N = ceil(n);
    k = 1:1:N;
    Fc = Fp/((10^(0.1*Ap)-1)^(1/2*N));
    Pole = Fc*1i*exp(1i*(2*k-1)*pi/(2*N));
    s = tf('s');
    butter_poly = 1;
    for i=1:N
        butter_poly = (1-s/Pole(i))*butter_poly;
    end
    Ha = 1/butter_poly;
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