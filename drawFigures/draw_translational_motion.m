%% Figure Position
set(gcf, 'Name', 'Position');

% Plot for x,y,z, u,v,w
numSubplot=3;
numData=6;
for i=1:numData
    indexSubplot=rem(i,numSubplot);
    if indexSubplot==1; figure
    elseif indexSubplot==0; indexSubplot=numSubplot;
    end
    subplot(numSubplot,1,indexSubplot)
    plot(T, Xlqr_data(i,:), T, X_data(i,:));
    xlabel(XLabels(1)); ylabel(YLabels(i));grid on;
    legend('LQR','Frequency-Shaped LQR')
end

%%  3D
%{%
% vidObj = VideoWriter(sprintf('Motion_f=%i.avi', freq));
% open(vidObj)


figure
set(gcf, 'Name', '3D Position');
az = -60.5; el = 45;
legend('expd','lqr'); 
x_min=min([X_data(1,:) Xlqr_data(1,:)])-2*l;
x_max=max([X_data(1,:) Xlqr_data(1,:)])+2*l;
y_min=min([X_data(2,:) Xlqr_data(2,:)])-2*l;
y_max=max([X_data(2,:) Xlqr_data(2,:)])+2*l;
z_min=min([X_data(3,:) Xlqr_data(3,:)])-2*l;
z_max=max([X_data(3,:) Xlqr_data(3,:)])+2*l;
for t=1:length(T)-1
    x = X_data(1,t);
    y = X_data(2,t);
    z = X_data(3,t); 
    phi = X_data(7,t);
    th = X_data(8,t);
    psi = X_data(9,t);
    x_lqr = Xlqr_data(1,t);
    y_lqr = Xlqr_data(2,t);
    z_lqr = Xlqr_data(3,t);
    phi_lqr = Xlqr_data(7,t);
    th_lqr = Xlqr_data(8,t);
    psi_lqr = Xlqr_data(9,t);    
    plot3(X_data(1,1:t),X_data(2,1:t),X_data(3,1:t),':g', Xlqr_data(1,1:t), Xlqr_data(2,1:t), Xlqr_data(3,1:t),':m'); grid on; 
    xlim([x_min x_max]); ylim([y_min y_max]); zlim([z_min z_max]);
    line([x_lqr+l*cos(th_lqr)*cos(psi_lqr) x_lqr-l*cos(th_lqr)*cos(psi_lqr)], [y_lqr+l*(sin(phi_lqr)*sin(th_lqr)*cos(psi_lqr)-cos(phi_lqr)*sin(psi_lqr)) y_lqr-l*(sin(phi_lqr)*sin(th_lqr)*cos(psi_lqr)-cos(phi_lqr)*sin(psi_lqr))], [z_lqr+l*(cos(phi_lqr)*sin(th_lqr)*cos(psi_lqr)+sin(phi_lqr)*sin(psi_lqr)) z_lqr-l*(cos(phi_lqr)*sin(th_lqr)*cos(psi_lqr)+sin(phi_lqr)*sin(psi_lqr))]);
    line([x_lqr+l*cos(th_lqr)*sin(psi_lqr) x_lqr-l*cos(th_lqr)*sin(psi_lqr)], [y_lqr+l*(sin(phi_lqr)*sin(th_lqr)*sin(psi_lqr)+cos(phi_lqr)*cos(psi_lqr)) y_lqr-l*(sin(phi_lqr)*sin(th_lqr)*sin(psi_lqr)+cos(phi_lqr)*cos(psi_lqr))], [z_lqr+l*(cos(phi_lqr)*sin(th_lqr)*sin(psi_lqr)-sin(phi_lqr)*cos(psi_lqr)) z_lqr-l*(cos(phi_lqr)*sin(th_lqr)*sin(psi_lqr)-sin(phi_lqr)*cos(psi_lqr))]);
    line([x+l*cos(th)*cos(psi) x-l*cos(th)*cos(psi)], [y+l*(sin(phi)*sin(th)*cos(psi)-cos(phi)*sin(psi)) y-l*(sin(phi)*sin(th)*cos(psi)-cos(phi)*sin(psi))], [z+l*(cos(phi)*sin(th)*cos(psi)+sin(phi)*sin(psi)) z-l*(cos(phi)*sin(th)*cos(psi)+sin(phi)*sin(psi))]);
    line([x+l*cos(th)*sin(psi) x-l*cos(th)*sin(psi)], [y+l*(sin(phi)*sin(th)*sin(psi)+cos(phi)*cos(psi)) y-l*(sin(phi)*sin(th)*sin(psi)+cos(phi)*cos(psi))], [z+l*(cos(phi)*sin(th)*sin(psi)-sin(phi)*cos(psi)) z-l*(cos(phi)*sin(th)*sin(psi)-sin(phi)*cos(psi))]);
    view(az, el);
    xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
    title(sprintf('%0.1f/%i [s]',t*dt,t_end));
    drawnow;

%     currFrame = getframe(gcf);
%     writeVideo( vidObj, currFrame );
end

% close( vidObj );
%}

%% FFT

n = 2^nextpow2(length(T));
fftx = fft(X_data(1,:),n);
fftxlqr = fft(Xlqr_data(1,:),n);
ffty = fft(X_data(2,:),n);
fftylqr = fft(Xlqr_data(2,:),n);
fftz = fft(X_data(3,:),n);
fftzlqr = fft(Xlqr_data(3,:),n);

Fs=1/dt;
f = Fs*(0:(n/2))/n;
Px = abs(fftx/n);
Pxlqr = abs(fftxlqr/n);
Py = abs(ffty/n);
Pylqr = abs(fftylqr/n);
Pz = abs(fftz/n);
Pzlqr = abs(fftzlqr/n);

range=20;
figure; 
subplot(3,1,1);
plot(f(1:range),Pxlqr(1:range), f(1:range), Px(1:range)); ylabel('{\itP_x}'); grid on;
legend('LQR','Frequency-Shaped LQR')
subplot(3,1,2);
plot(f(1:range),Pylqr(1:range), f(1:range), Py(1:range)); ylabel('{\itP_y}'); grid on;
subplot(3,1,3);
plot(f(1:range),Pzlqr(1:range), f(1:range), Pz(1:range)); ylabel('{\itP_z}'); grid on;
xlabel('Frequency [Hz]'); 
