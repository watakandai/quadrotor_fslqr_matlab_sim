function hd = draw_translational_motion(T, X_data, Xlqr_data, XLabels, YLabels, limit, legendPos)
%% Figure Position
set(gcf, 'Name', 'Position');

% Plot for x,y,z, u,v,w
numSubplot=3;
numData=6;
numFigure=numData/numSubplot;
y_min=zeros(numFigure,1);
y_max=zeros(numFigure,1);
for i=1:numFigure
    y_min(i,1)=1.1*min([X_data(3*i-2,:) Xlqr_data(3*i-2,:) X_data(3*i-1,:) Xlqr_data(3*i-1,:) X_data(3*i,:) Xlqr_data(3*i,:)]);
    y_max(i,1)=1.1*min([X_data(3*i-2,:) Xlqr_data(3*i-2,:) X_data(3*i-1,:) Xlqr_data(3*i-1,:) X_data(3*i,:) Xlqr_data(3*i,:)]);
end
for i=1:numData
    [countFig, remain]=quorem(i+numSubplot,numSubplot);
    indexSubplot=rem(i,numSubplot);
    if indexSubplot==1; figure; 
    elseif indexSubplot==0; indexSubplot=numSubplot;
    end
    subplot(numSubplot,1,indexSubplot)
    plot(T, Xlqr_data(i,:), T, X_data(i,:));
    if rem(i,numSubplot)==0
        xlabel(XLabels(1)); 
    end
    ylabel(YLabels(i));grid on;
    if rem(i,numSubplot)==1
        hd = legend({'LQR','Frequency-Shaped LQR'}, 'FontSize', 10, 'Orientation', 'horizontal', 'Position', legendPos, 'boxoff');
        set(hd, 'Box', 'off'); 
    end
    if limit~=0
        ylim([-limit limit]);
    else
        ylim([y_min(countFig,1) y_max(countFig,1)]);
    end
end

success = true;

