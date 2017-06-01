function [ EG ] = expandG(  G, numY, numU, ep )
% Assume that D11 is 0!!!!! Otherwise this expansion is meaningless
[Ga, Gb1, Gb2, Gc1, Gc2, Gd11, Gd12, Gd21, Gd22] = g2ss(G, numY, numU);
EGa = Ga;
EGb1 = [Gb1 zeros(size(Gb1, 1), size(Gd21,1)) ep*eye(size(Gb1, 1))];
EGb2 = Gb2;
EGc1 = [Gc1; zeros(size(Gd12,2), size(Gc1, 2)); ep*eye(size(Gc1, 2))];
EGc2 = Gc2;
EGd11 = zeros(size(EGc1,1),size(EGb1,2));
EGd12 = [Gd12; ep*eye(size(Gd12,2)); zeros(size(Gc1, 2) ,size(Gd12,2))];
EGd21 = [Gd21 ep*eye(size(Gd21,1)), zeros(size(Gd21,1), size(Gb1, 1))];
EGd22 = Gd22;
EG = pck(EGa, [EGb1 EGb2], [EGc1; EGc2], [EGd11 EGd12; EGd21 EGd22])
end

