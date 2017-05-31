%% build general plant
%{
systemnames = ' P Ws Wt Wd Wn';
inputvar =  '[ dist{6}; noise{12}; control{4} ]';
outputvar = '[ Ws; Wt; -Wn-P]';
input_to_P = '[ Wd; control ]';
input_to_Ws = '[ Wn(1:6)+P(1:6) ]';
input_to_Wt = '[ control ]';
input_to_Wd = '[ dist ]';
input_to_Wn = '[ noise ]';
sysoutname = 'G';
cleanupsysic = 'yes';
sysic;
minfo(G)
[AG, BG, CG, DG] = unpck(G);
SYS = ss(AG,BG, CG, DG);
pzplot(SYS)
spoles(G)
spoles(Ws)
[K, CL, gamma] = hinfsyn(G,12,4,1,10,0.01,2);
%}
%{%

systemnames = 'P Ws Wt Wn Wd';
inputvar = '[dist{12}; noise{4}; control{4}]';
outputvar = '[Ws; Wt; -P-Wd]';
input_to_P = '[control+Wn]';
input_to_Ws = '[P(1:3)+Wd(1:3)]';
input_to_Wt = '[control]';
input_to_Wn = '[noise]';
input_to_Wd = '[dist]'; 
sysoutname = 'G';
cleanupsysic='yes';
sysic;
hin_ic = sel(G, 1:19, 13:20);
[K,CL,GAM]=hinfsyn(G,12,4,1,10,0.01,2);
[Actr,Bctr,Cctr,Dctr]=unpck(K);

figure
omega = logspace(-2,6,100);
CL_g = frsp(CL,omega);
vplot('liv,lm',vsvd(CL_g))
title('Singular Value Plot of CL')
xlabel('Frequency (rad/sec)')
ylabel('Magnitude')
legend('x','y','z','{\it f}','{\tau_x}','{\tau_y}','{\tau_z}');

%% Frequency Response of K controller & Poles
figure
K_g = frsp(K, w);
vplot('liv,lm', K_g); title('Frequency response of controller')
xlabel('Frequency [rad/s]'), ylabel('Gain')

spoles(K)
%% Build Closed Loop with STARP
systemnames = ' P Wn ';
inputvar = '[ref{12}; noise{4}; dist{12}; control{4} ]';
outputvar = '[ P(1:3); ref-P-dist ]';
input_to_P = '[ control+Wn ]';
input_to_Wn = '[ noise ]';
sysoutname = 'sim_ic';
cleanupsysic = 'yes';
sysic
clp=starp(sim_ic, K, 12, 4);


%% RESPONSES (Reference, Disturbance, Noise)
% Reference Tracking
timedata=0;
tf=10;
ti=0.01;
stepdata=1;
ref=step_tr(timedata,stepdata,ti,tf);
ref0=abv(0,0,0);
Ref=abv(ref, ref, ref, ref0, ref0, ref0);
Noise=abv(0, 0, 0, 0);
dist=abv(0,0,0,0,0,0);
Dist=abv(dist,dist);
y=trsp(clp, abv(Ref,Noise,Dist),tf,ti);
figure
vplot(sel(y,1,1), sel(y,2,1), sel(y,3,1));
grid
title('Closed-loop reference response')
xlabel('Time (secs)')
ylabel('position [m]')
legend('x','y','z')

% Disturbance Response
timedata=0;
tf=10;
ti=0.01;
stepdata=1;
ref0=abv(0,0,0);
Ref=abv(ref0, ref0, ref0, ref0);
Noise=abv(0, 0, 0, 0);
dist = step_tr(timedata,stepdata,ti,tf);
Dist = abv(dist,dist,dist);
dist0 = abv(0,0,0);
Dist=abv(dist0, Dist, dist0, Dist);
y=trsp(clp, abv(Ref,Noise,Dist),tf,ti);
figure
vplot(sel(y,1,1), sel(y,2,1), sel(y,3,1));
grid
title('Closed-loop disturbance response')
xlabel('Time (secs)')
ylabel('position [m]')
legend('x','y','z')

% Noise Response
timedata=0;
tf=10;
ti=0.01;
stepdata=1;
ref0=abv(0,0,0);
Ref=abv(ref0, ref0, ref0, ref0);
noise=step_tr(timedata,stepdata,ti,tf);
Noise=abv(noise,noise,noise,noise);
dist=abv(0,0,0,0,0,0);
Dist=abv(dist,dist);
y=trsp(clp, abv(Ref,Noise,Dist),tf,ti);
figure
vplot(sel(y,1,1), sel(y,2,1), sel(y,3,1));
grid
title('Closed-loop noise response')
xlabel('Time (secs)')
ylabel('position [m]')
legend('x','y','z')

%% Sensitivity Function and Inverse of Weighting Function
omega=logspace(-4,2,100);
Wp_g=frsp(Ws,omega);
Wpi_g=minv(Wp_g);
sen_loop=sel(clp,1:3,17:28);
sen_g=frsp(sen_loop,omega);
vplot('liv,lm', Wpi_g, 'm--', vnorm(sen_g), 'y-');
legend('Inverse Weighting function', 'Nominal Sensitivity function')
title('CLOSED-LOOP Sensitivity Function')
xlabel('Frequency [rad/s]'); ylabel('Magnitude');



