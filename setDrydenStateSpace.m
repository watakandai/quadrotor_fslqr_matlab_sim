function [Au, Bu, Cu, Du, Av, Bv, Cv, Dv, Aw, Bw, Cw, Dw, Cwind] = setDrydenStateSpace(Vwind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Dryden Wind Model                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
height = 6;
Lw = height;
Lu = height / (0.177+0.000823*height)^1.2;
Lv = Lu;

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