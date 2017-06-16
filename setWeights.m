%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Frequency Weight                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gain=100; 
f=0.5; w=2*pi*f; num=w; den=[1 w];
f=0.5; ze=1.3; w=2*pi*f; numBand=[0 2*ze*w 0]; denBand=[1 2*ze*w w^2];
f1=0.01; f2=0.05;  w1=2*pi*f1; w2=2*pi*f2; numLag=[1 w2]; denLag=[1 w1]; 
f=0.5; ze=0.5; w=2*pi*f; numBef=[1 2*ze*w w^2]; denBef=[1 0 w^2];
    num=conv(num, numBef); den=conv(den,denBef);
    e = nd2sys(numBef, denBef, 10);
    q = nd2sys(num, den, gain);
    q_g = frsp(q, W); 
    e_g = frsp(e, W);
    xq=daug(q,q,1);
    xq1=daug(1,1,1);
    xe=daug(e, e, 1, 1);
    Xq=daug(xq, xq, xq1, xq1, xe);
    [Aq,Bq,Cq,Dq]=unpck(Xq);
    
gain=10; f=0.1; w=2*pi*f; num=w; den=[1 w];
    r = nd2sys(num, den, gain); 
    Xr=daug(1,r,r,1);
    [Ar,Br,Cr,Dr]=unpck(Xr);
    r_g = frsp(r, W); r_g=minv(r_g); figure; vplot('liv,lm', q_g, r_g);
    title('Frequency Weight'); xlabel('Frequency [rad/s]'); ylabel('Gain [dB]'); legend('{\itQ}', '{\itR}');
    
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