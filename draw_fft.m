function [f, Px, Pxlqr] = draw_fft(T,dt, X_data, Xlqr_data, Vw_data)
%% FFT

n = 2^nextpow2(length(T));
fftx = fft(X_data(1,:),n);
fftxlqr = fft(Xlqr_data(1,:),n);
ffty = fft(X_data(2,:),n);
fftylqr = fft(Xlqr_data(2,:),n);
fftz = fft(X_data(3,:),n);
fftzlqr = fft(Xlqr_data(3,:),n);
fftVwind = fft(Vw_data(1,:),n);

Fs=1/dt;
f = Fs*(0:(n/2))/n;
Px = abs(fftx/n);
Pxlqr = abs(fftxlqr/n);
Py = abs(ffty/n);
Pylqr = abs(fftylqr/n);
Pz = abs(fftz/n);
Pzlqr = abs(fftzlqr/n);
PVwind = abs(fftVwind/n);


range=10;
figure; 
subplot(3,1,1);
plot(f(1:range),Pxlqr(1:range), f(1:range), Px(1:range)); ylabel('{\itP_x}'); grid on;
legend('LQR','Frequency-Shaped LQR')
subplot(3,1,2);
plot(f(1:range),Pylqr(1:range), f(1:range), Py(1:range)); ylabel('{\itP_y}'); grid on;
subplot(3,1,3);
plot(f(1:range),Pzlqr(1:range), f(1:range), Pz(1:range)); ylabel('{\itP_z}'); grid on;
xlabel('Frequency [Hz]'); 

%{
figure
plot(f, PVwind(1:n/2+1)); grid on;
%}
