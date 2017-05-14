%% Figure Input
figure
% set(0, 'DefaultFigurePosition', pPos)
set(gcf, 'Name', 'Input LQR');

% f
subplot(4,1,1);
plot(T_data,U_data(1,:),'LineWidth',2)
ylabel('f [Nm]')
% axis([0 t_end -pos_lim pos_lim])
grid on
% \tau_x
subplot(4,1,2);
plot(T_data,U_data(2,:),'LineWidth',2)
ylabel('\tau_x [Nm]')
% axis([0 t_end -pos_lim pos_lim])
grid on
% \tau_y
subplot(4,1,3);
plot(T_data,U_data(3,:),'LineWidth',2)
xlabel('Time [s]'); ylabel('\tau_y [Nm]')
% axis([0 t_end -pos_lim pos_lim])
grid on
% \tau_z
subplot(4,1,4);
plot(T_data,U_data(4,:),'LineWidth',2)
xlabel('Time [s]'); ylabel('\tau_z [Nm]')
% axis([0 t_end -pos_lim pos_lim])
grid on