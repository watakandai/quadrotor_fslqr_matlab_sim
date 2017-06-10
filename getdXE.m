function dXE=getdXE(XE, A, B, Cref, U, Xref)
Axe = [A    zeros(length(A), size(Cref,1));
       -Cref   zeros(size(Cref,1), size(Cref,1))];
Bxe = [B; zeros(size(Cref,1), size(B,2))];
Bref = [zeros(length(A), size(Xref,1)); ones(size(Xref,1))];

dXE = Axe*XE + Bxe*U + Bref*Xref;