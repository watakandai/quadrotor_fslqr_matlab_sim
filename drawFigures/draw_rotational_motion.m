%% Figure Angle
figure
set(gcf, 'Name', 'Angle LQR');
numSubplot=3;
for i=7:12
    indexSubplot=rem(i,numSubplot);
    if indexSubplot==1; figure
    elseif indexSubplot==0; indexSubplot=numSubplot;
    end
    subplot(numSubplot,1,indexSubplot)
    plot(T, Xlqr_data(i,:)*180/pi(), T,  X_data(i,:)*180/pi());
    xlabel(XLabels(1)); ylabel(YLabels(i));grid on;
    legend('LQR','Frequency-Shaped LQR')
end
