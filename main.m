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
% close all
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
t_end = 10;
dt = 0.01;
T = t_start:dt:t_end;
% Initial States
X0 = [0 0 0 0 0 0 0 0 0 0 0 0]';
U0 = [0 0 0 0]';

% Reference States
Xref = [0 0 0 0]';  % x, y, z, psi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Main Simulation                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setWeight for desired output and input
setWeights
% setWeightsNew

% Calculate Control Gain K
getLQRGain;
% getHinfGain
% WORST gain of CLOSED LOOP Transer Function 
% checkSingularValue 
%%
Amp = 6;
freq = 0.5;
flagSine=0; % 1 is Sine, 0 is just one wave
% rungekutta simulation
rungekutta
rungekutta_explqr
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Figures                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f, tx, ty, tz
% draw_input
% phi, th, psi, p, q, r
% draw_rotational_motion
% x, y, z, u, v, w,
draw_translational_motion
%%
% OpenLoop Analysis (LQR)
%{
openLoop = tf(Pss*K_lqr);
figure
for i=1:size(B,2)
    for j=1:size(A,1)
        bode(openLoop(j,i),w); 
        hold on
    end
end
%}

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Disturbance Resp                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pap = pck(Aap,Bap,Cap,Dap);
Wd = daug(daug(0, 0, 0, 1, 1, 1), daug(0, 0, 0, 0, 0, 0));

systemnames = ' Pap Wd ';
inputvar = '[ dist{12}; control{4} ]';
outputvar = '[ Pap; -Pap-Wd ]';
input_to_Wd = '[ dist ]';
input_to_Pap = '[ control ]';
sysoutname = 'sim_ic';
cleanupsysic = 'yes';
sysic
CL=starp(sim_ic, Gk, 12, 4);
CLtrans = sel(CL, 1:3, 1:12);
CLtrans_g=frsp(CLtrans,W);
figure
vplot('liv,lm',vsvd(CLtrans_g));
legend('{\it x}','{\it y}','{\it z}');
% legend('{\it x}','{\it y}','{\it z}','{\it u}','{\it v}','{\it w}');
title('Disturbance Response');xlabel('Frequency [rad/s]'); ylabel('Gain [dB]');

CLrotat = sel(CL, 7:9, 1:12);
CLrotat_g=frsp(CLrotat,W);
figure
vplot('liv,lm',vsvd(CLrotat_g));
legend('{\phi}','{\theta}','{\psi}');
% legend('{\phi}','{\theta}','{\psi}','{\it p}','{\it q}','{\it r}');
title('Disturbance Response');xlabel('Frequency [rad/s]'); ylabel('Gain [dB]');

%}
% drawFigures
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              From Excel                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VRexcelData
%%
%{
%% Define Systems
systems = tf(ss(A, B, C, D));
% systems_lqr = tf(ss(A-B*K_lqr, B, C, D));
% systems_hinf = tf(ss(A-B*K_lqr, B, C, D));
%% Bode
draw_bode_diagram
%% step & Impulse
sys = ss(A-B*K_lqr, B, C, D);
draw_step_impulse_diagram
%% draw poles
draw_poles_diagram
%}

