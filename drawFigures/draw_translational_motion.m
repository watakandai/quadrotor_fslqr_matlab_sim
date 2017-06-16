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
    plot(T, X_data(i,:), T, Xlqr_data(i,:));
    xlabel(XLabels(1)); ylabel(YLabels(i));grid on;
    legend('Frequency-Shaped LQR','LQR')
end

%%  3D
%{
vidObj = VideoWriter(sprintf('Motion_f=%i.avi', freq));
open(vidObj)


figure
set(gcf, 'Name', '3D Position');
az = -60.5; el = 45;
for t=1:length(T)-1
    plot3(X_data(1,1:t), X_data(2,1:t), X_data(3,1:t)); grid on; hold on;
    plot3(Xlqr_data(1,1:t), Xlqr_data(2,1:t), Xlqr_data(3,1:t));
    xlim([min(X_data(1,:)) max(X_data(1,:))]); ylim([min(X_data(2,:)) max(X_data(2,:))]); zlim([min(X_data(3,:)) max(X_data(3,:))]);
    xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
    title(sprintf('%0.3f/%i [s]',t*dt,t_end));
    view(az, el);
    drawnow;

    currFrame = getframe(gcf);
    writeVideo( vidObj, currFrame );
end

close( vidObj );
%}

%% FFT

n = 2^nextpow2(length(T));
fftx = fft(X_data(1,:),n);
Fs=1/dt;
f = Fs*(0:(n/2))/n;
P = abs(fftx/n);
figure
plot(f,P(1:n/2+1))

