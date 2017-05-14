

%% Figure Position
figure('Position',[2562   98    638   898])
set(gcf, 'Name', 'Position');

% x
subplot(3,1,1);   %?????????????
plot(T_data,X_data(1,:),'LineWidth',2)
ylabel('x [m]')
% set(gca,'XTick',(0:t_end/10:t_end),'XTickLabel', (0:t_end/10:t_end));
% set(gca,'YTick',(-th_y:0.002:th_y),'YTickLabel', (-th_y:0.002:th_y));
axis([0 t_end -2 2])
grid on   %????????
% y
subplot(3,1,2);
plot(T_data,X_data(2,:),'LineWidth',2)
ylabel('y [m]')
axis([0 t_end -2 2])
grid on
% z
subplot(3,1,3);
plot(T_data,X_data(3,:),'LineWidth',2)
xlabel('Time [s]'); ylabel('z [m]')
axis([0 t_end -2 2])
grid on


%% Figure VELOCITY
figure('Position', [1922   98    638   898])
set(gcf, 'Name', 'Velocity');

% u
subplot(3,1,1);
plot(T_data,X_data(4,:),'LineWidth',2)
ylabel('u [m/s]')
grid on 
% v
subplot(3,1,2);
plot(T_data,X_data(5,:),'LineWidth',2)
ylabel('v [m/s]')
grid on 
% u
subplot(3,1,3);
plot(T_data,X_data(6,:),'LineWidth',2)
xlabel('Time [s]'); ylabel('w [m/s]')
grid on 


%%  3D
figure('Position', [1          41        1920         963])
set(gcf, 'Name', '3D Position');
plot3(X_data(1,:), X_data(2,:), X_data(3,:), 'LineWidth',2)
xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
xlim([-2 2]); ylim([-2 2]); zlim([-2*2 2*2]);
grid on
