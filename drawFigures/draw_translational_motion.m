function success = draw_translational_motion(T, X_data, Xlqr_data, XLabels, YLabels)
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
success = true;

