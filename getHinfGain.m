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
systemnames = 'P Ws Wt Wd';
inputvar = '[ref{3}; dist{3}; control{4}]';
outputvar = '[Ws; Wt; ref-P(1:3)-Wd; -P(4:12)]';
input_to_P = '[control]';
input_to_Ws = '[ref-P(1:3)-Wd]';
input_to_Wt = '[P]';
input_to_Wd = '[dist]';
sysoutname = 'G';
cleanupsysic='yes';
sysic;


[Ga, Gb1, Gb2, Gc1, Gc2, Gd11, Gd12, Gd21, Gd22] = g2ss(G, 12, 4);
ep = 0.001;
[EG] = expandG(G, 12, 4, ep);
%}

%{
systemnames = 'P Ws Wt Wn';
inputvar = '[noise{12}; control{4}]';
outputvar = '[Ws; Wt; -P-Wn]';
input_to_P = '[control]';
input_to_Ws = '[P(1:3)]';
input_to_Wt = '[control]';
input_to_Wn = '[noise]';
sysoutname = 'G';
cleanupsysic='yes';
sysic;
[Ga, Gb1, Gb2, Gc1, Gc2, Gd11, Gd12, Gd21, Gd22] = g2ss(G, 12, 4);
ep = 0.001;
[EG] = expandG(G, 12, 4, ep);
%}

[K,CL,GAM]=hinfsyn(EG,12,4,1,10,0.01,2);
[Actr,Bctr,Cctr,Dctr]=unpck(K);
CL = sel(CL, [1:7], [1:16]);

figure
omega = logspace(-2,6,100);
CL_g = frsp(CL,omega);
vplot('liv,lm',vsvd(CL_g))
title('Singular Value Plot of CL')
xlabel('Frequency (rad/sec)')
ylabel('Magnitude')
legend('x','y','z','{\it f}','{\tau_x}','{\tau_y}','{\tau_z}');

%% Hinfinity Solvability Condition
% Precondition
if rank(Gd22) ~= 0
    display('Gd22 is not 0! Meaning, Gyu is not Stricly Proper')
end
if rank(Gd11) ~= 0
    display('Gd11 is not 0! Meaning, Gzw is not Strictly Proper')
end

% A1) Controllability Condition
co=ctrb(Ga, Gb2);
if rank(co)==size(Ga)
   disp('This system is controllable.')
else
   if rank(co)==0
      disp('This system is uncontrollable.')
   else
      disp('This system is stabilizable.')
   end
end
Controllability = rank(co)
% B1) Observability Condition 
obs=obsv(Ga, Gc2);
if rank(obs)==size(Ga)
   disp('This system is observable.')
else
   if rank(obs)==0
      disp('This system is unobservable.')
   else
      disp('This system is detectable.')
   end
end
Observability = rank(obs)

% A2) Vertically Full Rank
sizeZ = size(Gc1, 1);
sizeU = size(Gb2, 2);
if sizeZ >= sizeU
    disp('[Satisfied] Output Z is larger than input U');
else
    disp('[Not Satisfied] Output Z is smaller than input U');
end
if rank(Gd12) == sizeZ
    disp('[Satisfied] D12 is full rank')
else 
    disp('[Not Satisfied] D12 is not full rank. Please expand the General Plant');
end
% B2) Horizontally Full Rank
sizeY = size(Gc2, 1);
sizeW = size(Gb1, 2);
if sizeY >= sizeW
    disp('[Satisfied] Output Y is larger than input W');
else
    disp('[Not Satisfied] Output Y is smaller than input W');
end
if rank(Gd21) == sizeW
    disp('[Satisfied] D21 is full rank')
else 
    disp('[Not Satisfied] D21 is not full rank. Please expand the General Plant');
end

%% Frequency Response of K controller & Poles
figure
W=logspace(-1,2,100);
K_g = frsp(K, W);
vplot('liv,lm', vsvd(K_g)); title('Frequency response of controller')
xlabel('Frequency [rad/s]'), ylabel('Gain')
legend('{\it f}','{\tau_x}','{\tau_y}','{\tau_z}');

spoles(K)
%% Build Closed Loop with STARP
systemnames = ' P Wd';
inputvar = '[ref{3}; dist{3}; control{4} ]';
outputvar = '[ P; ref-P(1:3)-Wd; -P(4:12) ]';
input_to_P = '[ control ]';
input_to_Wd = '[ dist ]';
sysoutname = 'sim_ic';
cleanupsysic = 'yes';
sysic
clp=starp(sim_ic, K, 12, 4);

%% Sensitivity Function and Inverse of Weighting Function
omega=logspace(-4,2,100);
Wp_g=frsp(Ws,omega);
Wpi_g=minv(Wp_g);
sen_loop=sel(clp,1:12,4:6);
sen_g=frsp(sen_loop,omega);
vplot('liv,lm', Wpi_g, 'm--', vnorm(sen_g), 'y-');
legend('Inverse Weighting function', 'Nominal Sensitivity function')
title('CLOSED-LOOP Sensitivity Function')
xlabel('Frequency [rad/s]'); ylabel('Magnitude');


%% RESPONSES (Reference, Disturbance, Noise)
% Reference Tracking
timedata=0;
tf=10;
ti=0.01;
stepdata=1;

ref=step_tr(timedata,stepdata,ti,tf);
ref0=abv(0,0,0);
Ref=abv(ref, ref, ref);
Dist=abv(0,0,0);
y=trsp(clp, abv(Ref,Dist),tf,ti);
figure
vplot(sel(y,1,1), sel(y,2,1), sel(y,3,1));
grid
title('Closed-loop reference response')
xlabel('Time (secs)')
ylabel('position [m]')
legend('x','y','z')

% Disturbance Response
Ref=abv(0,0,0);
dist = step_tr(timedata,stepdata,ti,tf);
Dist = abv(dist,dist,dist);
y=trsp(clp, abv(Ref,Dist),tf,ti);
figure
vplot(sel(y,1,1), sel(y,2,1), sel(y,3,1));
grid
title('Closed-loop disturbance response')
xlabel('Time (secs)')
ylabel('position [m]')
legend('x','y','z')



