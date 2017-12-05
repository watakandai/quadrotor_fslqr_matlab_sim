function hd = draw_rotational_motion(T, X_data, Xlqr_data, XLabels, YLabels, limit, legendPos)
%% Figure Angle
figure
set(gcf, 'Name', 'Angle LQR');
numSubplot=3;
numData=6;
for i=7:12
    indexSubplot=rem(i,numSubplot);
    if indexSubplot==1; figure;
    elseif indexSubplot==0; indexSubplot=numSubplot;
    end
    subplot(numSubplot,1,indexSubplot)
    plot(T, Xlqr_data(i,:)*180/pi(), T,  X_data(i,:)*180/pi());
    if rem(i,numSubplot)==0
        xlabel(XLabels(1)); 
    end
    ylabel(YLabels(i));grid on;
    if rem(i,numSubplot)==1
        hd = legend({'LQR','Frequency-Shaped LQR'}, 'FontSize', 10, 'Orientation', 'horizontal', 'Location', legendPos);
        set(hd, 'Box', 'off');
    end
    if limit~=0
        ylim([-limit limit]);
    end
end
