%% Hinfinity Closed Loop (Including Weights Ws, Wt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checking for Singular Value of the designed closed loop               %
% Singular Value => the WORST gain of transfer functions from           %
% [dist,noise]->[outputs]                                               %
% In this case                                                          %
% CLoutput means,   [dist,noise]->[x,y,z,v,phi,theta,psi]               %
% CLinput means,    [dist,noise]->[f,tx,ty,tz]                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{%
omega = logspace(-4,4,100);
% Singluar Value of outputs
CLoutput = sel(CL,[1:3,7:9],[13:18]);
CLoutput_g = frsp(CLoutput,omega);
figure
vplot('liv,lm',vsvd(CLoutput_g))
legend('x','y','z','\phi','\theta','\psi')
%}

% Singluar Value of Inputs
%{
CLinput = sel(CL,[8:11],[1:16]);
CLinput_g = frsp(CLinput,omega);
figure
vplot('liv,lm',vsvd(CLinput_g))
legend('f','tx','ty','tz')
%}
