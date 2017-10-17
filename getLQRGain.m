function K_lqr = getLQRGain(A, B)
%%

Q = [10 0  0  0  0  0  0  0  0  0  0  0;
     0   10 0  0  0  0  0  0  0  0  0  0;
     0   0  1  0  0  0  0  0  0  0  0  0;
     0   0  0  1  0  0  0  0  0  0  0  0;
     0   0  0  0  1  0  0  0  0  0  0  0;
     0   0  0  0  0  1  0  0  0  0  0  0;
     0   0  0  0  0  0  1  0  0  0  0  0;
     0   0  0  0  0  0  0  1  0  0  0  0;
     0   0  0  0  0  0  0  0  1  0  0  0;
     0   0  0  0  0  0  0  0  0  1  0  0;
     0   0  0  0  0  0  0  0  0  0  1  0;
     0   0  0  0  0  0  0  0  0  0  0  1];
R = eye(4);
[K_lqr, P, e] = lqr(A, B, Q, R);
