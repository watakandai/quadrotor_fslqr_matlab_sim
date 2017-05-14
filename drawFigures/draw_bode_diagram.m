% w/o control
% systems = tf(ss(A, B, C, D));             % defined in main .m 
mag_f2z         = bode(systems(3,1),W);
mag_tx2y        = bode(systems(2,2),W);
mag_tx2phi      = bode(systems(7,2),W);
mag_ty2x        = bode(systems(1,3),W);
mag_ty2theta    = bode(systems(8,3),W);
mag_tz2psi      = bode(systems(9,4),W);
mag_f2z         = 20*log10(mag_f2z);
mag_tx2y        = 20*log10(mag_tx2y);
mag_tx2phi      = 20*log10(mag_tx2phi);
mag_ty2x        = 20*log10(mag_ty2x);
mag_ty2theta    = 20*log10(mag_ty2theta);
mag_tz2psi      = 20*log10(mag_tz2psi);
% w/ lqr control
% systems_lqr = tf(ss(A-B*K_lqr, B, C, D));     % defined in main .m 
mag_lqr_f2z         = bode(systems_lqr(3,1),W);
mag_lqr_tx2y        = bode(systems_lqr(2,2),W);
mag_lqr_tx2phi      = bode(systems_lqr(7,2),W);
mag_lqr_ty2x        = bode(systems_lqr(1,3),W);
mag_lqr_ty2theta    = bode(systems_lqr(8,3),W);
mag_lqr_tz2psi      = bode(systems_lqr(9,4),W);
mag_lqr_f2z         = 20*log10(mag_lqr_f2z);
mag_lqr_tx2y        = 20*log10(mag_lqr_tx2y);
mag_lqr_tx2phi      = 20*log10(mag_lqr_tx2phi);
mag_lqr_ty2x        = 20*log10(mag_lqr_ty2x);
mag_lqr_ty2theta    = 20*log10(mag_lqr_ty2theta);
mag_lqr_tz2psi      = 20*log10(mag_lqr_tz2psi);
% w/ hinf control

% systems_hinf = tf(ss(A-B*K, B, C, D));        % defined in main .m 
mag_hinf_f2z         = bode(systems_hinf(3,1),W);
mag_hinf_tx2y        = bode(systems_hinf(2,2),W);
mag_hinf_tx2phi      = bode(systems_hinf(7,2),W);
mag_hinf_ty2x        = bode(systems_hinf(1,3),W);
mag_hinf_ty2theta    = bode(systems_hinf(8,3),W);
mag_hinf_tz2psi      = bode(systems_hinf(9,4),W);
mag_hinf_f2z         = 20*log10(mag_hinf_f2z);
mag_hinf_tx2y        = 20*log10(mag_hinf_tx2y);
mag_hinf_tx2phi      = 20*log10(mag_hinf_tx2phi);
mag_hinf_ty2x        = 20*log10(mag_hinf_ty2x);
mag_hinf_ty2theta    = 20*log10(mag_hinf_ty2theta);
mag_hinf_tz2psi      = 20*log10(mag_hinf_tz2psi);


figure('Position',[1921 97 1280 907])
subplot(2,3,1)
semilogx(W,mag_ty2x(1,:), W, mag_lqr_ty2x(1,:), W,mag_hinf_ty2x(1,:));            title('X / TauY');      xlabel('Frequency [Hz]'); ylabel('Gain [dB]'); legend('w/o control', 'w/ LQR control', 'w/ Hinf control'); axis([10^(-2) 10^2 -100 100]);
grid on
subplot(2,3,2)
semilogx(W,mag_tx2y(1,:), W, mag_lqr_tx2y(1,:), W,mag_hinf_tx2y(1,:));            title('Y / TauX');      xlabel('Frequency [Hz]'); ylabel('Gain [dB]'); legend('w/o control', 'w/ LQR control', 'w/ Hinf control'); axis([10^(-2) 10^2 -100 100]);
grid on
subplot(2,3,3); 
semilogx(W,mag_f2z(1,:), W, mag_lqr_f2z(1,:), W,mag_hinf_f2z(1,:));              title('Z / Force');     xlabel('Frequency [Hz]'); ylabel('Gain [dB]'); legend('w/o control', 'w/ LQR control', 'w/ Hinf control'); axis([10^(-2) 10^2 -100 100]);
grid on
subplot(2,3,4)
semilogx(W,mag_tx2phi(1,:), W, mag_lqr_tx2phi(1,:), W,mag_hinf_tx2phi(1,:));        title('Phi / TauX');    xlabel('Frequency [Hz]'); ylabel('Gain [dB]'); legend('w/o control', 'w/ LQR control', 'w/ Hinf control'); axis([10^(-2) 10^2 -100 100]);
grid on
subplot(2,3,5)
semilogx(W,mag_ty2theta(1,:), W, mag_lqr_ty2theta(1,:), W,mag_hinf_ty2theta(1,:));    title('Theta / TauY');  xlabel('Frequency [Hz]'); ylabel('Gain [dB]'); legend('w/o control', 'w/ LQR control', 'w/ Hinf control'); axis([10^(-2) 10^2 -100 100]);
grid on
subplot(2,3,6)
semilogx(W,mag_tz2psi(1,:), W, mag_lqr_tz2psi(1,:), W,mag_hinf_tz2psi(1,:));        title('Psi / TauZ');    xlabel('Frequency [Hz]'); ylabel('Gain [dB]'); legend('w/o control', 'w/ LQR control', 'w/ Hinf control'); axis([10^(-2) 10^2 -100 100]);
grid on
