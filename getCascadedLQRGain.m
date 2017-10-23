function [Kxy, Gxy, FFxy, FFinitxy, Kz, Gz, FFz, FFinitz, Kphi, Gphi, FFphi, FFinitphi, Kpsi, Gpsi, FFpsi, FFinitpsi] = getCascadedLQRGain(Aerror, Bxy, Bz, Bphi, Bpsi)


%% Z
R = 1;
Q = diag([1, 1, 1]);
Pe = care(Aerror, Bxy, Q, R);
P11=Pe(1:2,1:2);
P12=Pe(1:2,3);
P22=Pe(3,3);
B = Bxy(1:2);
MO = [Aerror(1:2,1:2) B; 1 0 0];
Kxy = -inv(R)*B'*P11;
Gxy = -inv(R)*B'*P12;
FFxy = [-Kxy+Gxy*inv(P22)*P12' 1]*inv(MO)*[zeros(2,1); 1];
FFinitxy = -Gxy*inv(P22)*P12';
% Kx = lqr(Aerror, Bpos, Q, R);
% Ky = Kx;

%% XY
R = 1;
Q = diag([1, 1, 1]);
Pe = care(Aerror, Bz, Q, R);
P11=Pe(1:2,1:2);
P12=Pe(1:2,3);
P22=Pe(3,3);
B = Bz(1:2);
MO = [Aerror(1:2,1:2) B; 1 0 0];
Kz = -inv(R)*B'*P11;
Gz = -inv(R)*B'*P12;
FFz = [-Kz+Gz*inv(P22)*P12' 1]*inv(MO)*[zeros(2,1); 1];
FFinitz = -Gz*inv(P22)*P12';
% Kz = lqr(Aerror, Bz, Q, R);

%% Phi, Theta
R = 1;
Q = diag([1, 1, 1]);
Pe = care(Aerror, Bphi, Q, R);
P11=Pe(1:2,1:2);
P12=Pe(1:2,3);
P22=Pe(3,3);
B = Bphi(1:2);
MO = [Aerror(1:2,1:2) B; 1 0 0];
Kphi = -inv(R)*B'*P11;
Gphi = -inv(R)*B'*P12;
FFphi = [-Kphi+Gphi*inv(P22)*P12' 1]*inv(MO)*[zeros(2,1); 1];
FFinitphi = -Gphi*inv(P22)*P12';
% Kphi = lqr(Aerror, Bphi, Q, R);
% Kth = lqr(Aerror, Bth, Q, R);

%% Psi
R = 1;
Q = diag([1, 1, 1]);
Pe = care(Aerror, Bpsi, Q, R);
P11=Pe(1:2,1:2);
P12=Pe(1:2,3);
P22=Pe(3,3);
B = Bpsi(1:2);
MO = [Aerror(1:2,1:2) B; 1 0 0];
Kpsi = -inv(R)*B'*P11;
Gpsi = -inv(R)*B'*P12;
FFpsi = [-Kpsi+Gpsi*inv(P22)*P12' 1]*inv(MO)*[zeros(2,1); 1];
FFinitpsi = -Gpsi*inv(P22)*P12';
% Kpsi = lqr(Aerror, Bpsi, Q, R);

