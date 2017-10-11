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
     0   0   0   0   0   0   0   -g  0   0   0   0;
     0   0   0   0   0   0   g   0   0   0   0   0;
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
     -1/m  0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     1/Ixx   0       0;
     0     0       1/Iyy   0;
     0     0       0       1/Izz];
%}

C = eye(12); 
D = zeros(size(C,1), size(B,2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Augmented Plant                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cref = [1 0 0 0 0 0 0 0 0 0 0 0;
        0 1 0 0 0 0 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 1 0 0 0];
Aap = [A    zeros(length(A), size(Cref,1));
       -Cref   zeros(size(Cref,1), size(Cref,1))];
Bap = [B; zeros(size(Cref,1), size(B,2))];
Cap = [C zeros(size(C,1), size(Cref,1))];
Dap = zeros(size(Cap,1), size(D,2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Dryden Wind Model                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
height = 6;
Lw = height;
Lu = height / (0.177+0.000823*height)^1.2;
Lv = Lu;

Vwind=6;
W20=Vwind;
sigw = 0.1*W20;
sigu = sigw*(1/(0.177+0.000823*height)^0.4);
sigv = sigu;
num=1; den=[Lu/Vwind 1]; gain=sigu * sqrt(2*Lu/(pi*Vwind));
Hu = nd2sys(num, den, gain);
num=[sqrt(3)*Lv/Vwind 1]; den=[Lv/Vwind 1]; den=conv(den,den); gain=sigv*sqrt(Lv/(pi*Vwind));
Hv = nd2sys(num, den, gain);
Hw = Hv;
[Au, Bu, Cu, Du]=unpck(Hu);
[Av, Bv, Cv, Dv]=unpck(Hv);
[Aw, Bw, Cw, Dw]=unpck(Hw);
Cwind = [Cu                             zeros(size(Cu,1), size(Cv,2)+size(Cw,2));
        zeros(size(Cv,1),size(Cu,2))    Cv          zeros(size(Cv,1),size(Cw,2));
        zeros(size(Cw,1),size(Cu,2)+size(Cv,2))     Cw];

%%
%{
% Disturbances (This matrix will be needed for Hinfinity Controller)
%{
%   fwx,    fwy,    fwz,    twx,    twy,    twz
Dd = [0        0       0       0       0       0;
      0        0       0       0       0       0;
      0        0       0       0       0       0;
      1/m      0       0       0       0       0;
      0        1/m     0       0       0       0;
      0        0       1/m     0       0       0;
      0        0       0       0       0       0;
      0        0       0       0       0       0;
      0        0       0       0       0       0;
      0        0       0       1/Ixx   0       0;
      0        0       0       0       1/Iyy   0;
      0        0       0       0       0       1/Izz];
% this all should be 1. as disturbances applied will be the dryden wind
% model
% https://jp.mathworks.com/help/aeroblks/drydenwindturbulencemodeldiscrete.html
% a lot to think of
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             poles and zeros                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = pck(A,B,C,D);
% Bode Diagram of Plant P

P_g = frsp(P,W);
%{
for i=1:length(A)
   Psel_g = sel(P_g, i, 1:size(B,2));
   figure
   vplot('bode', Psel_g); title(sprintf('%i',i));
   legend('u','tx','ty','tz');
end
%}

% poles and pole diagram of Plant P
Pss = ss(A,B,C,D);
%{
for i=1:size(B,2)
    for j=1:size(A,1)
        bode(Pss(j,i),w); 
        hold on
    end
end
%}
% figure
% pzmap(Pss);

% Transfer Function of P (from 4inputs to 12 outputs)
tfmat = tf(Pss);
spoles(P)

%{
tf1=tf([1],[1 1]);
tf2=tf([1],[1 2 1]);
tf3=tf([1],[1 3 3 1]);
tf4=tf([1], [1 4 6 4 1]);
systf=[ 0   0   tf4     0;
        0   tf4 0       0;
        tf2 0   0       0;
        0   0   tf3     0;
        0   tf3 0       0;
        tf1 0   0       0;
        0   tf2 0       0;
        0   0   tf2     0;
        0   0   0       tf2;
        0   tf1 0       0;
        0   0   tf1     0;
        0   0   0       tf1];
Pss = ss(systf);
P = pck(Pss.A,Pss.B,Pss.C,Pss.D);
%}
%}
%% Checking for Controllability & Observability
co=ctrb(A,B);
if rank(co)==size(A)
   disp('This system is controllable.')
else
   if rank(co)==0
      disp('This system is uncontrollable.')
   else
      disp('This system is stabilizable.')
   end
end
Controllability = rank(co)
obs=obsv(A,C);
if rank(obs)==size(A)
   disp('This system is observable.')
else
   if rank(obs)==0
      disp('This system is unobservable.')
   else
      disp('This system is detectable.')
   end
end
Observability = rank(obs)
