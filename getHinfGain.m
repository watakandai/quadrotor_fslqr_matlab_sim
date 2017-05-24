%% Weight -> xdot=Ax+Bu, y=Cx;
% draw general plant on a piece of paper
% xdot_in = Ain*xin, Bin*u*in;

% which weight?
% x,y,z for cetain omega/ u,v,w for low omega
% u for high omega
% [Ax, Bx, Cx, Dx] = tf2ss(num, den);

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
%{
systemnames = 'P Ws Wt';
inputvar = '[dist{12}; control{4}]';
outputvar = '[Ws; Wt; P + dist]';
input_to_P = '[control]';
input_to_Ws = '[P+dist]';
input_to_Wt = '[P]';
sysoutname = 'G';
cleanupsysic='yes';
sysic;
[K,CL,GAM]=hinfsyn(G,12,4,1,10,0.01,2);
%}

[K,CL,GAM]=mixsyn(P,[],[],[]);
%% think of if hinfsyn cannot solve?
% epsilon1
% ?g???ngeneral plant????
%

%% calculate K
% [K, CL, gamma] = hinfsyn(G,12,4,1,10,0.01,2);
