function [Kx, Ky, Kz, Kphi, Kth, Kpsi] = getCascadedLQRGain(Aerror, Bpos, Balt, Bphi, Bth, Bpsi);

R = 1;

Q = diag([100, 10, 1]);
Kx = lqr(Aerror, Bpos, Q, R);
Ky = Kx;
Q = diag([10, 1, 1]);
Kz = lqr(Aerror, Balt, Q, R);

Kphi = Kx;
Kth = Ky;
Kpsi = Kz;

Q = diag([100, 10, 1]);
Kx = lqr(Aerror, Bphi, Q, R);
Ky = lqr(Aerror, Bth, Q, R);
Q = diag([10, 1, 1]);
Kz = lqr(Aerror, Bpsi, Q, R);