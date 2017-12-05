function success = draw_input(T, U_data, Ulqr_data, XLabels, YLabels_input, limit, legendPos)
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
    if rem(i,numSubplot)==0
        xlabel(XLabels(1)); 
    end
    ylabel(YLabels_input(i));grid on;
    if rem(i,numSubplot)==1
        hd = legend({'LQR','Frequency-Shaped LQR'}, 'FontSize', 10, 'Orientation', 'horizontal', 'Location', legendPos);
        set(hd, 'Box', 'off');
    end
    if limit~=0
        ylim([-limit limit]);
    end
end

success = true;
