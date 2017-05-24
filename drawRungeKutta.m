% Translational Position
plot(T, X_data(1,:), T, X_data(2,:), T, X_data(3,:));
xlabel('Time [s]'); ylabel('Position [m]'); grid on;

% Rotation Position
plot(T, X_data(7,:), T, X_data(8,:), T, X_data(9,:));
xlabel('Time [s]'); ylabel('Rotation [m]'); grid on;

% Input
plot(T, U_data(1,:), T, U_data(2,:), T, U_data(3,:), T, U_data(4,:));
xlabel('Time [s]'); ylabel(' [m]');grid on;