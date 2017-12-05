function [Au, Bu, Cu, Du, Av, Bv, Cv, Dv, Aw, Bw, Cw, Dw, Cwind] = setDrydenStateSpace(Vwind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Dryden Wind Model                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Please check Matlab Document Below
%   https://jp.mathworks.com/help/aeroblks/drydenwindturbulencemodelcontinuous.html
%   Dryden Wind Model based on the wind at the height of 20 ft
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global meter2feet
height = 20;    % in [ft] (= 6m)

% Scale Lengths @ 20ft According to MIL-F-8785C
Lw = height/2;
Lu = height / (0.177+0.000823*height)^1.2;
Lv = Lu/2;

Vwind = Vwind*meter2feet;
% Wind Speed @ 20ft
W20=Vwind;
% Turbulence Intensities
sigw = 0.1*W20;
sigu = sigw*(1/(0.177+0.000823*height)^0.4);
sigv = sigu;

% Dryden Wind Model Transfer Function
% Dryden Wind Model is defined in Spectral Densities, but we can assume it
% as white noise being filtered by a Transfer Function that has the same
% exact Spectral Densities
% white noise ---------> Transfer Function ---------> Dryden Wind

% X
num=1;
den=[Lu/Vwind 1];
gain=sigu * sqrt(2*Lu/(pi*Vwind));
Hu = nd2sys(num, den, gain);
% Y
num=[2*sqrt(3)*Lv/Vwind 1];
den=[2*Lv/Vwind 1]; den=conv(den,den);
gain=sigv*sqrt(2*Lv/(pi*Vwind));
Hv = nd2sys(num, den, gain);
% Z
num=[2*sqrt(3)*Lw/Vwind 1];
den=[2*Lw/Vwind 1]; den=conv(den,den);
gain=sigv*sqrt(2*Lw/(pi*Vwind));
Hw = nd2sys(num, den, gain);


% unpack the transfer function to get space state equation
[Au, Bu, Cu, Du]=unpck(Hu);
[Av, Bv, Cv, Dv]=unpck(Hv);
[Aw, Bw, Cw, Dw]=unpck(Hw);
Cwind = [Cu                             zeros(size(Cu,1), size(Cv,2)+size(Cw,2));
        zeros(size(Cv,1),size(Cu,2))    Cv          zeros(size(Cv,1),size(Cw,2));
        zeros(size(Cw,1),size(Cu,2)+size(Cv,2))     Cw];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% be careful, everything is calculated in FEEEEEEET!!!!!
% Must convert it to m/s when in use (for example in rungekutta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


