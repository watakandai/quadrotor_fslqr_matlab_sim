function [K, G, FF, FFini] = getLQRGainServo(A, B, Ae, Be, Ce, setPosition)
Re = eye(size(B,2));
if setPosition==true
    Qe = diag([10, 10, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
else
    Qe = diag([1, 1, 1, 10, 10, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
end

Pe = care(Ae, Be, Qe, Re);

P11=Pe(1:12,1:12);
P12=Pe(1:12,13:16);
P22=Pe(13:16,13:16);
MO = [A     B; 
      Ce    zeros(size(Ce,1),size(B,2))];

K = -inv(Re)*B'*P11;
G = -inv(Re)*B'*P12;

FF = [-K+G*inv(P22)*P12' eye(size(B,2))]*inv(MO)*[zeros(size(A,1), size(B,2)); eye(size(B,2))];
FFini = -G*inv(P22)*P12';