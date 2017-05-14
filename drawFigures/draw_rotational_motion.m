%% Figure Angle
figure
pPos = [2562   98    638   898];
set(0, 'DefaultFigurePosition', pPos)
set(gcf, 'Name', 'Angle LQR');

% phi
subplot(3,1,1);
plot(T_data,X_data(7,:),'LineWidth',2)
ylabel('\phi [rad]')
% axis([0 t_end -pos_lim pos_lim])
grid on
% theta
subplot(3,1,2);
plot(T_data,X_data(8,:),'LineWidth',2)
ylabel('\theta [rad]')
% axis([0 t_end -pos_lim pos_lim])
grid on
% psi
subplot(3,1,3);
plot(T_data,X_data(9,:),'LineWidth',2)
xlabel('Time [s]'); ylabel('\psi [rad]')
% axis([0 t_end -pos_lim pos_lim])
grid on
%% Figure Angluar Velocity
figure
pVel = [1922   98    638   898];
set(0, 'DefaultFigurePosition', pVel)
set(gcf, 'Name', 'Angluar Velocity LQR');

% p
subplot(3,1,1);
plot(T_data,X_data(10,:),'LineWidth',2)
ylabel('p [rad/s]')
% axis([0 t_end -pos_lim pos_lim])
grid on
% q
subplot(3,1,2);
plot(T_data,X_data(11,:),'LineWidth',2)
ylabel('q [rad/s]')
% axis([0 t_end -pos_lim pos_lim])
grid on
% r
subplot(3,1,3);
plot(T_data,X_data(12,:),'LineWidth',2)
xlabel('Time [s]'); ylabel('r [rad/s]')
% axis([0 t_end -pos_lim pos_lim])