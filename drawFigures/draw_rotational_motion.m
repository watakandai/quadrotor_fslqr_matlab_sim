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
    plot(T, X_data(i,:), T,  Xlqr_data(i,:));
    xlabel(XLabels(1)); ylabel(YLabels(i));grid on;
    legend('Frequency-Shaped LQR','LQR')
end
