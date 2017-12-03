function [Ak, Bk, Ck, Dk]=getSDREController(A, B, C, D, Aq,Bq,Cq,Dq, Ar,Br,Cr,Dr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Augmented General Plant                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Aag=[A                              zeros(length(A),length(Aq))     B*Cr;
    Bq                                Aq                              zeros(length(Aq),length(Ar));
    zeros(length(Ar),length(A))     zeros(length(Ar),length(Aq))    Ar];
Bag=[B*Dr;
    zeros(length(Aq), size(Br,2));
    Br];
Cag=[Dq Cq zeros(size(Cq,1), length(Ar))]; Dag=zeros(size(Cag,1), size(Bag,2));
[K_lqr, Pg, e] = lqr(Aag, Bag, eye(size(Aag)), eye(size(Bag,2)));
Kx=K_lqr(:,1:length(A));     Kq=K_lqr(:,length(A)+1:length(A)+length(Aq));     Kr=K_lqr(:,length(A)+length(Aq)+1:length(A)+length(Aq)+length(Ar));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Controller                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ak=[ Aq         zeros(length(Aq), size(Ar-Br*Kr,2));
     -Br*Kq     Ar-Br*Kr];
Bk=[ Bq; -Br*Kx];
Ck=[ -Dr*Kq  Cr-Dr*Kr];
Dk= -Dr*Kx;
