function [Ak, Bk, Ck, Dk]=getSDREController(A, B, C, D, Aq,Bq,Cq,Dq, Ar,Br,Cr,Dr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Augmented Plant                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cref = [1 0 0 0 0 0 0 0 0 0 0 0;
        0 1 0 0 0 0 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 1 0 0 0];
Aap = [A    zeros(length(A), size(Cref,1));
       -Cref   zeros(size(Cref,1), size(Cref,1))];
Bap = [B; zeros(size(Cref,1), size(B,2))];
Cap = [C zeros(size(C,1), size(Cref,1))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Augmented General Plant                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Aag=[Aap                              zeros(length(Aap),length(Aq))     Bap*Cr;
    Bq                                Aq                              zeros(length(Aq),length(Ar));
    zeros(length(Ar),length(Aap))     zeros(length(Ar),length(Aq))    Ar];
Bag=[Bap*Dr;
    zeros(length(Aq), size(Br,2));
    Br];
Cag=[Dq Cq zeros(size(Cq,1), length(Ar))]; Dag=zeros(size(Cag,1), size(Bag,2));
[K_lqr, Pg, e] = lqr(Aag, Bag, eye(size(Aag)), eye(size(Bag,2)));
Kx=K_lqr(:,1:length(Aap));     Kq=K_lqr(:,length(Aap)+1:length(Aap)+length(Aq));     Kr=K_lqr(:,length(Aap)+length(Aq)+1:length(Aap)+length(Aq)+length(Ar));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Controller                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ak=[ Aq         zeros(length(Aq), size(Ar-Br*Kr,2));
     -Br*Kq     Ar-Br*Kr];
Bk=[ Bq; -Br*Kx];
Ck=[ -Dr*Kq  Cr-Dr*Kr];
Dk= -Dr*Kx;
