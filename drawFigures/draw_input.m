%% Figure Input
figure
set(gcf, 'Name', 'Input LQR');

numSubplot=4;
numData=4;
for i=1:numSubplot
    indexSubplot=rem(i,numSubplot);
    if indexSubplot==1; figure
    elseif indexSubplot==0; indexSubplot=numSubplot;
    end
    subplot(numSubplot,1,indexSubplot)
    plot(T, U_data(i,:), T, Ulqr_data(i,:));
    xlabel(XLabels(1)); ylabel(YLabels_input(i));grid on;
    legend('Frequency-Shaped LQR','LQR')
end
