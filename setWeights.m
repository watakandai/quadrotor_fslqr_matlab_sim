%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Frequency Weight                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gain=1;
f=0.5; w=2*pi*f; num=w; den=[1 w];
f=0.5; ze=1; w=2*pi*f; numBand=[0 2*ze*w 0]; denBand=[1 2*ze*w w^2];
f1=0.01; f2=1;  w1=2*pi*f1; w2=2*pi*f2; numLag=[1 w2]; denLag=[1 w1]; 
f=0.5; ze=0.1; w=2*pi*f; numBef=[1 2*ze*w w^2]; denBef=[1 0 w^2];
f=0.001; ze=0.6; w=2*pi*f; numHigh=[1 0]; denHigh=[1 w];
    e = nd2sys(numHigh, denHigh, 1);
    num=conv(numBand,numBef); den=conv(denBand,denBef);
    qx = nd2sys(num,den, 10);
    qv = nd2sys(numHigh, denHigh, 1);
    
    e_g = frsp(e, W);
    qx_g = frsp(qx, W); 
    qv_g = frsp(qv, W); 
    
    xqx=daug(qx,qx,qx);
    xqv=daug(1,1,1);
    xq1=daug(1,1,1);
    xe=daug(1, 1, 1, 1);
    
    Xq=daug(xqx, xqv, xq1, xq1, xe);
    [Aq,Bq,Cq,Dq]=unpck(Xq);
    
gain=1; f=10; w=2*pi*f; num=w; den=[1 w];
    r = nd2sys(num, den, gain); 
    Xr=daug(r,r,r,1);
    [Ar,Br,Cr,Dr]=unpck(Xr);
    r_g = frsp(r, W); r_g=minv(r_g); 
    qx_g_unpck = vunpck(vnorm(qx_g));
    r_g_unpck = vunpck(vnorm(r_g));
    figure; loglog(W/(2*pi), qx_g_unpck, W/(2*pi), r_g_unpck); grid on;
    xlim([10^-2 10^2]);
    title('Frequency Weight'); xlabel('Frequency [Hz]'); ylabel('Gain [dB]'); legend('{\itq}', '{\itr}');
    
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