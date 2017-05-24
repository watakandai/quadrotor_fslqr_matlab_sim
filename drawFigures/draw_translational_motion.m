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
    plot(T, X_data(i,:));
    xlabel(XLabels(1)); ylabel(YLabels(i));grid on;
    legend
end

%%  3D
% set(gcf, 'Name', '3D Position');
% plot3(X_data(1,:), X_data(2,:), X_data(3,:))
% xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
% xlim([-2 2]); ylim([-2 2]); zlim([-2*2 2*2]);
% grid on;