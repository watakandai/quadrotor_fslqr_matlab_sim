close all
% step
figure;
set(gcf, 'Name', 'Step Input');
% subplot(2,3,1)
% step(systems(1,3),systems_lqr(1,3),systems_hinf(1,3)); title('Step X/\tau_y'); xlabel('Time [s]'); ylabel('X [m]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,2)
% step(systems(2,2),systems_lqr(2,2),systems_hinf(2,2)); title('Step Y/\tau_x'); xlabel('Time [s]'); ylabel('Y [m]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,3)
% step(systems(3,1),systems_lqr(3,1),systems_hinf(3,1)); title('Step Z/F'); xlabel('Time [s]'); ylabel('Z [m]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,4)
% step(systems(7,2),systems_lqr(7,2),systems_hinf(7,2)); title('Step \phi/\tau_x'); xlabel('Time [s]'); ylabel('\phi [rad]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,5)
% step(systems(8,3),systems_lqr(8,3),systems_hinf(8,3)); title('Step \theta/\tau_y'); xlabel('Time [s]'); ylabel('\theta [rad]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,6)
% step(systems(9,4),systems_lqr(9,4),systems_hinf(9,4)); title('Step \psi/\tau_z'); xlabel('Time [s]'); ylabel('\psi [rad]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');

subplot(2,3,1)
step(systems_lqr(1,3)); title('Step X/\tau_y'); xlabel('Time [s]'); ylabel('X [m]');legend('w/ LQR control');
subplot(2,3,2)
step(systems_lqr(2,2)); title('Step Y/\tau_x'); xlabel('Time [s]'); ylabel('Y [m]');legend('w/ LQR control');
subplot(2,3,3)
step(systems_lqr(3,1)); title('Step Z/F'); xlabel('Time [s]'); ylabel('Z [m]');legend('w/ LQR control');
subplot(2,3,4)
step(systems_lqr(7,2)); title('Step \phi/\tau_x'); xlabel('Time [s]'); ylabel('\phi [rad]');legend('w/ LQR control');
subplot(2,3,5)
step(systems_lqr(8,3)); title('Step \theta/\tau_y'); xlabel('Time [s]'); ylabel('\theta [rad]');legend('w/ LQR control');
subplot(2,3,6)
step(systems_lqr(9,4)); title('Step \psi/\tau_z'); xlabel('Time [s]'); ylabel('\psi [rad]');legend('w/ LQR control');

% impulse
figure;
set(gcf, 'Name', 'Impulse Input');
% subplot(2,3,1)
% impulse(systems(1,3),systems_lqr(1,3),systems_hinf(1,3)); title('Impulse X/\tau_y'); xlabel('Time [s]'); ylabel('X [m]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,2)
% impulse(systems(2,2),systems_lqr(2,2),systems_hinf(2,2)); title('Impulse Y/\tau_x'); xlabel('Time [s]'); ylabel('Y [m]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,3)
% impulse(systems(3,1),systems_lqr(3,1),systems_hinf(3,1)); title('Impulse Z/F'); xlabel('Time [s]'); ylabel('Z [m]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,4)
% impulse(systems(7,2),systems_lqr(7,2),systems_hinf(7,2)); title('Impulse \phi/\tau_x'); xlabel('Time [s]'); ylabel('\phi [rad]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,5)
% impulse(systems(8,3),systems_lqr(8,3),systems_hinf(8,3)); title('Impulse \theta/\tau_y'); xlabel('Time [s]'); ylabel('\theta [rad]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');
% subplot(2,3,6)
% impulse(systems(9,4),systems_lqr(9,4),systems_hinf(9,4)); title('Impulse \psi/\tau_z'); xlabel('Time [s]'); ylabel('\psi [rad]');legend('w/o control', 'w/ LQR control', 'w/ Hinf control');

subplot(2,3,1)
impulse(systems_lqr(1,3)); title('Impulse X/\tau_y'); xlabel('Time [s]'); ylabel('X [m]');legend('w/ LQR control');
subplot(2,3,2)
impulse(systems_lqr(2,2)); title('Impulse Y/\tau_x'); xlabel('Time [s]'); ylabel('Y [m]');legend('w/ LQR control');
subplot(2,3,3)
impulse(systems_lqr(3,1)); title('Impulse Z/F'); xlabel('Time [s]'); ylabel('Z [m]');legend('w/ LQR control');
subplot(2,3,4)
impulse(systems_lqr(7,2)); title('Impulse \phi/\tau_x'); xlabel('Time [s]'); ylabel('\phi [rad]');legend('w/ LQR control');
subplot(2,3,5)
impulse(systems_lqr(8,3)); title('Impulse \theta/\tau_y'); xlabel('Time [s]'); ylabel('\theta [rad]');legend('w/ LQR control');
subplot(2,3,6)
impulse(systems_lqr(9,4)); title('Impulse \psi/\tau_z'); xlabel('Time [s]'); ylabel('\psi [rad]');legend('w/ LQR control');

