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
m = 0.650;
Ixx = 7.5*10^(-3);
Iyy = 7.5*10^(-3);
Izz = 1.3*10^(-2);

m=1.37;
Ixx = 0.0219;
Iyy = 0.0109;
Izz = 0.0306;
g=9.81; 
rho = 1.225;
l = 0.23;
global meter2feet feet2meter
meter2feet = 3.28084;
feet2meter = 1/meter2feet;


%%% Debug Mode
% true  == show figures, controllability and etc....
DEBUG = true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Initial States & Reference States                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation Initial Setup ------------------------------------------------
t_start=0;
t_end = 20;
dt = 0.01;
T = t_start:dt:t_end;
% Initial States
X0 = [0 0 0 0 0 0 0 0 0 0 0 0]';
U0 = [m*g 0 0 0]';
    
% Reference States
Xref = [0 0 0 0]';  % x, y, z, psi
% Xref = [0 0 0 0 0 0 0 0 0 0 0 0]';
% Freq.
W=logspace(-4,3,100);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Main Simulation                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% State Space A,B,C,D
[A, B, C, D] = setStateSpace(m, g, Ixx, Iyy, Izz);
Ce = [1 0 0 0 0 0 0 0 0 0 0 0;
      0 1 0 0 0 0 0 0 0 0 0 0
      0 0 1 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 1 0 0 0];
Ae = [A zeros(size(A,1),size(Ce,1)); -Ce zeros(size(Ce,1),size(Ce,1))];
Be = [B; zeros(size(Ce,1),size(B,2))];

if DEBUG==true
    [controllability, observability] = checkContObser(A,B,C);
    disp(controllability);
    disp(observability);
end
%{

[Aerror, Cerror, Bxy, Bz, Bphi, Bth, Bpsi] = setCascadedStateSpace(m, g, Ixx, Iyy, Izz);
[Kxy, Gxy, FFxy, FFinitxy, Kz, Gz, FFz, FFinitz, Kphi, Gphi, FFphi, FFinitphi, Kpsi, Gpsi, FFpsi, FFinitpsi] = getCascadedLQRGain(Aerror, Bxy, Bz, Bphi, Bpsi);
Aerr = Aerror(1:2,1:2);
zero22 = zeros(2,2);
zero21 = zeros(2,1);
Axyz = [Aerr zero22 zero22;
        zero22 Aerr zero22;
        zero22 zero22 Aerr];
Bxyz = [Bxy(1:2) zero21 zero21;
        zero21 Bxy(1:2) zero21;
        zero21 zero21 Bz(1:2)];
Bz = [Bz [0; 0; 1]];
%}

% Dryden Wind Model State Space
Vwind=6;
[Au, Bu, Cu, Du, Av, Bv, Cv, Dv, Aw, Bw, Cw, Dw, Cwind] = setDrydenStateSpace(Vwind);
setPosition=false;
% setWeight for desired output and input
[Aq,Bq,Cq,Dq, Ar,Br,Cr,Dr] = setFreqShapedWeights(W, DEBUG, setPosition);
% setWeightsNew

% Calculate Control Gain K
[Ak, Bk, Ck, Dk] = getFreqShapedLQRGain(A, B, Aq, Bq, Cq, Dq, Ar, Br, Cr, Dr);
% K_lqr = getLQRGain(A, B);
[Ke, Ge, FFe, FFinie] = getLQRGainServo(A, B, Ae, Be, Ce, setPosition);
% getHinfGain
% WORST gain of CLOSED LOOP Transer Function 
% checkSingularValue 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Wind Flag                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Amp = Vwind;
freq = 0.5;
%%% Wind Flag
% 111   == Continous Sine Wave
% 1     == 1 Sine Wave
% 3     == Dryden Wind
flagWind=111;
%%% Wind Stop Time
% 0     == Wind Does not Stop
% >0    == Time at Wind Stops
wind_stop_time = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Rungekutta                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rungekutta simulation
rungekutta
rungekutta_lqr
% Set 0 Just for visualization when the other controller diverges (== Hassann) 
mycontroller_off = false;
lqr_off = false;
if mycontroller_off==true
    X_data = zeros(size(X_data));
    U_data = zeros(size(U_data));
end
if lqr_off == true
    Xlqr_data = zeros(size(Xlqr_data));
    Ulqr_data = zeros(size(Ulqr_data));
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Figures                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% limit for axis range
% 0     == no limit
% >0    == limit in figure
limit = 0;
legendPos = [0.1148 0.9208 0.4571 0.0440];
% h = get(gcf, 'Children')
% set(h(3), 'Position', [0.1148 0.9265 0.8127 0.0709])
% set(hd, 'Position', [0.1148 0.9265 0.8127 0.0709])
% legendPos = 'north';
% originalOrange = [0.85 0.325 0.098]
% originalBlue = [0.0 0.447 0.741]
% f, tx, ty, tz
success = draw_input(T, U_data, Ulqr_data, XLabels, YLabels_input, limit, legendPos);
% phi, th, psi, p, q, r
hd = draw_rotational_motion(T, X_data, Xlqr_data, XLabels, YLabels, limit, legendPos);
% x, y, z, u, v, w,
hd = draw_translational_motion(T, X_data, Xlqr_data, XLabels, YLabels, limit, legendPos);
hd3 = draw_3d_animation(T, X_data, Xlqr_data, l, dt, t_end, limit, legendPos);
[f, Px, Pxlqr, h] = draw_fft(T, dt, T_data, X_data, Xlqr_data, Vw_data, legendPos, XLabels, YLabels); 


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

