function [Ak, Bk, Ck, Dk] = getFreqShapedLQRGain(A, B,Aq,Bq,Cq,Dq,Ar,Br,Cr,Dr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Augmented General Plant                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Aag=[A                              zeros(length(A),length(Aq))     B*Cr;
    Bq                                Aq                              zeros(length(Aq),length(Ar));
    zeros(length(Ar),length(A))     zeros(length(Ar),length(Aq))    Ar];
Bag=[B*Dr;
    zeros(length(Aq), size(Br,2));
    Br];
% Cag=[Dq Cq zeros(size(Cq,1), length(Ar))]; Dag=zeros(size(Cag,1), size(Bag,2));

[K, Pg, e] = lqr(Aag, Bag, eye(size(Aag)), eye(size(Bag,2)));

Kx=K(:,1:length(A));     Kq=K(:,length(A)+1:length(A)+length(Aq));     Kr=K(:,length(A)+length(Aq)+1:length(A)+length(Aq)+length(Ar));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Controller                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ak=[ Aq         zeros(length(Aq), size(Ar-Br*Kr,2));
     -Br*Kq     Ar-Br*Kr];
Bk=[ Bq; -Br*Kx];
Ck=[ -Dr*Kq  Cr-Dr*Kr];
Dk= -Dr*Kx;
%{
Gk = pck(Ak, Bk, Ck, Dk);
Gk_g=frsp(Gk,W);
figure
vplot('liv,lm',vsvd(Gk_g)); 
legend('{\it f}','{\tau_x}','{\tau_y}','{\tau_z}'); grid on;
title('Controller');xlabel('Frequency [rad/s]'); ylabel('Gain [dB]');
%}

%{
function [K, G, FF, FFini] = getLQRGainServo(A, B, Ae, Be, Ce)
Re = eye(size(B,2));
Qe = diag([10, 10, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
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
%}