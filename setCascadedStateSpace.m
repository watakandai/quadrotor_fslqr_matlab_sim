function [Aerror, Cerror, Bxy, Bz, Bphi, Bth, Bpsi] = setCascadedStateSpace(m, g, Ixx, Iyy, Izz)
Aerror = [0 1 0; 
          0 0 0; 
          -1 0 0];
Cerror = diag([1,1,1]);
f = m*g;
Bxy = [0; f/m; 0];
Bz = [0; 1; 0];
Bphi = [0; 1/Ixx; 0];
Bth = [0; 1/Iyy; 0];
Bpsi = [0; 1/Izz; 0];