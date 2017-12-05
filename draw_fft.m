function [f, Px, Pxlqr, h] = draw_fft(T, dt, T_data, X_data, Xlqr_data, Vw_data, legendPos, XLabels, YLabels)
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


start=5;
stop =15;
range=20;
figure; 
subplot(3,1,1);
plot(f(start:stop), Pxlqr(start:stop), f(start:stop), Px(start:stop)); ylabel('{\itP_x}'); grid on;
hd = legend({'LQR','Frequency-Shaped LQR'}, 'FontSize', 9, 'Orientation', 'horizontal', 'Location', legendPos);
set(hd, 'Box', 'off'); 
subplot(3,1,2);
plot(f(start:stop),Pylqr(start:stop), f(start:stop), Py(start:stop)); ylabel('{\itP_y}'); grid on;
subplot(3,1,3);
plot(f(start:stop),Pzlqr(start:stop), f(start:stop), Pz(start:stop)); ylabel('{\itP_z}'); grid on;
xlabel('Frequency, Hz'); 

%{%
figure
plot(f, PVwind(1:n/2+1)); grid on;
xlabel('Frequency, Hz'); 

figure
h = plot(T_data, Vw_data(1,:), T_data, Vw_data(2,:), T_data, Vw_data(3,:)); grid on;
legend({'{\itV_x}', '{\itV_y}', '{\itV_z}'}, 'Location', 'southeast');
xlabel(XLabels(1)); ylabel('Wind Velocity, m/s'); 
%}
