% Lisense belongs to
% Takahashi Lab @ Keio University
% Created by: Kandai Watanabe (Bachelor4 @ FY2016) 
% Created on: 2017/01/01
% Hope you have a happy new year.... 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model  
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
clc
close all
setFormats
setLabels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Parameters                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Physical Parameters of Quadrotor 
setParameters
% State Space A,B,C,D
% setStateSpace
setStateSpace_lqr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Initial States & Reference States                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation Initial Setup ------------------------------------------------
t_start=0;
t_end = 5;
dt = 0.01;
T = t_start:dt:t_end;
% Initial States
X0 = [0 0 0 0 0 0 0 0 0 0 0 0]';
U0 = [m*g 0 0 0]';
X = X0;
U = U0;
Umotor = [m*g 0 0 0]';
% Reference States
Xref = [1 1 1 0 0 0 0 0 0 0 0 0]';
amp = 0.3;
f = 1;
Xref_sin = amp * sin(2*pi*f*T);
% boxes to store data
T_data = T;                                    % time t
X_data = zeros(length(X), length(T_data));     % state x
U_data = zeros(length(U), length(T_data));     % input u to the motor
% Umotor_data = zeros(length(U), length(T_data));     % input umotor to the plant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Main Simulation                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setWeight for desired output and input
% setWeights
setWeightsNew
% Calculate Control Gain K
getLQRGain;
% getHinfGain
% WORST gain of CLOSED LOOP Transer Function 
% checkSingularValue 
%%
% rungekutta simulation
% Xctr_data = zeros(size(Actr,1),length(T_data));
% Xctr = zeros(size(Actr,1),1);

% motor first order lag, https://fenix.tecnico.ulisboa.pt/downloadFile/395139421061/EXTENDED%20ABSTRACT.pdf
% Tf = 0.1;
% alpha=dt/(Tf+dt);
Dist = [0 0 0 0.05 0.05 0.05 0 0 0 0 0 0]';
rungekutta


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Figures                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f, tx, ty, tz
draw_input
% phi, th, psi, p, q, r
draw_rotational_motion
% x, y, z, u, v, w,
draw_translational_motion
%%
% OpenLoop Analysis (LQR)
openLoop = tf(Pss*K_lqr);
figure
for i=1:size(B,2)
    for j=1:size(A,1)
        bode(openLoop(j,i),w); 
        hold on
    end
end

% drawFigures
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              From Excel                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VRexcelData
%%
%{%
%% Define Systems
systems = tf(ss(A, B, C, D));
systems_lqr = tf(ss(A-B*K_lqr, B, C, D));
systems_hinf = tf(ss(A-B*K_lqr, B, C, D));
%% Bode
draw_bode_diagram
%% step & Impulse
sys = ss(A-B*K_lqr, B, C, D);
draw_step_impulse_diagram
%% draw poles
draw_poles_diagram
%}

