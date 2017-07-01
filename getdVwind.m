function dVw=getdVwind(Vwind, Wv, Au,Av,Aw,Bu,Bv,Bw)
U = Vwind(length(Au),1);
V = Vwind(length(Au)+1:length(Au)+length(Av), 1);
W = Vwind(length(Au)+length(Av)+1:length(Au)+length(Av)+length(Aw), 1);
dU = Au*U+Bu*Wv(1,1);
dV = Av*V+Bv*Wv(2,1);
dW = Aw*W+Bw*Wv(3,1);

dVw = [dU; dV; dW];