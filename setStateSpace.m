function [A, B, C, D] = setStateSpace(m, g, Ixx, Iyy, Izz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Reference:  Quadrotor control: modeling, nonlinearcontrol design, and simulation
%               by FRANCESCO SABATINO
%   MODEL:
%               xdot = A*x + B*u + Dd*d
%               y    = C*x + D*u
%   where:      x = state;          % [x,y,z,u,v,w,phi,th,psi,p,q,r]
%               u = input;          % [f,tx,ty,tz]
%               d = disturbance;    % [fwx,fwy,fwz,twx,twy,tw]
%               y = output;         % Leave it for now. Depends on sensors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% States
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Quadrotor SS                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    x,  y,  z,  u,  v,  w, phi, th, psi, p, q,  r;
%{%
A = [0   0   0   1   0   0   0   0   0   0   0   0;
     0   0   0   0   1   0   0   0   0   0   0   0;
     0   0   0   0   0   1   0   0   0   0   0   0;
     0   0   0   0   0   0   0   g   0   0   0   0;
     0   0   0   0   0   0   -g  0   0   0   0   0;
     0   0   0   0   0   0   0   0   0   0   0   0;
     0   0   0   0   0   0   0   0   0   1   0   0;
     0   0   0   0   0   0   0   0   0   0   1   0;
     0   0   0   0   0   0   0   0   0   0   0   1;
     0   0   0   0   0   0   0   0   0   0   0   0;
     0   0   0   0   0   0   0   0   0   0   0   0;
     0   0   0   0   0   0   0   0   0   0   0   0];

%    f     tx      ty      tz
B = [0     0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     0       0       0;
     1/m   0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     1/Ixx   0       0;
     0     0       1/Iyy   0;
     0     0       0       1/Izz];
%}

C = eye(12); 
D = zeros(size(C,1), size(B,2));



