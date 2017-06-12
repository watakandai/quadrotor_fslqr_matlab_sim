close all
vidObj = VideoWriter('Gain.avi');
open(vidObj)

P = pck(A,B,C,D);
Wd = daug(daug(0, 0, 0, 0.1, 0.1, 0.1), daug(0, 0, 0, 0.1, 0.1, 0.1));

n=length(X);
Ns=1:n;
count=1;
gain=1; f=0.5; ze=0.7; w=2*pi*f; num=[1 2*ze*w w^2]; den=[1 0 0]; q = nd2sys(num,den,gain);
gain=100; f=1; ze=0.7; w=2*pi*f; num=[0 0 w^2]; den=[1 2*ze*w w^2]; r = nd2sys(num, den, gain);
gain=10; f=0.5; ze=1.3; w=2*pi*f; num=[0 2*ze*w 0]; den=[1 2*ze*w w^2]; q = nd2sys(num,den,gain); 

h=waitbar(0,'Name','Calculating Every Combinations','CreateCancelBtn'); allComb=0; countComb=0;
figure;
for i=1:n
    allComb=allComb+size(nchoosek(Ns,i),1);
end
for i=1:n
    % Choose i out of Ns, ex) 12Ci
    Indexes=nchoosek(Ns,i);     % all combinations
    numComb=size(Indexes,1);    % num of combinations
    for j=1:numComb
        countComb=countComb+1;
        waitbar(countComb/allComb,h,sprintf('Nth:%i, Combo:%i, Loops:%i/%i',i,numComb,countComb,allComb));
        % one of all combinations ex) 1 2 5 10
        index=Indexes(j,:);
        for k=1:n
            % choosing index of Xq 
            if k<=i
                elem=index(k);
            else
                elem=0;
            end
            
            if k==elem
                if k==1
                    Xq=q;
                else
                    Xq=daug(Xq,q);
                end
            else
                if k==1
                    Xq=1;
                else
                    Xq=daug(Xq,1);
                end
            end
        end
        Xr=daug(r,r,r,r);
        [Ar,Br,Cr,Dr]=unpck(Xr);
        [Aq,Bq,Cq,Dq]=unpck(Xq);
        % Forming Expanded Plant ss
        Aag=[A                              zeros(length(A),length(Aq))     B*Cr;
            Bq                              Aq                              zeros(length(Aq),length(Ar));
            zeros(length(Ar),length(A))     zeros(length(Ar),length(Aq))    Ar];
        Bag=[B*Dr; 
            zeros(length(Aq), size(Br,2));
            Br];
        Cag=[Dq Cq zeros(size(Cq,1), length(Ar))]; Dag=zeros(size(Cag,1), size(Bag,2));
        try
            [K_lqr, Pg, e] = lqr(Aag, Bag, eye(size(Aag)), eye(size(Bag,2)));
        catch
            continue
        end
        Kx=K_lqr(:,1:length(A));     Kq=K_lqr(:,length(A)+1:length(A)+length(Aq));     Kr=K_lqr(:,length(A)+length(Aq)+1:length(A)+length(Aq)+length(Ar));

        % Forming Controller ss
        Ak=[ Aq         zeros(length(Aq), size(Ar-Br*Kr,2));
            -Br*Kq     Ar-Br*Kr];
        Bk=[ Bq; -Br*Kx];
        Ck=[ -Dr*Kq  Cr-Dr*Kr];
        Dk= -Dr*Kx;
        Gk = pck(Ak, Bk, Ck, Dk);
        
        systemnames = ' P Wd ';
        inputvar = '[ dist{12}; control{4} ]';
        outputvar = '[ P; -P-Wd ]';
        input_to_Wd = '[ dist ]';
        input_to_P = '[ control ]';
        sysoutname = 'sim_ic';
        cleanupsysic = 'yes';
        sysic
        CL=starp(sim_ic, Gk, 12, 4);
        
        for k=1:i
            combinations(count,k)=index(1,k);
        end
        CLx=sel(CL, 1, 1:12);
        CLy=sel(CL, 2, 1:12);
        CLz=sel(CL, 3, 1:12);
        CLx_g=frsp(CLx,W);
        vplot('liv,lm', vnorm(CLx_g)); hold on;
        title(sprintf('%i, ',index));
        currFrame = getframe(gcf);
        writeVideo( vidObj, currFrame );
        
        CLy_g=frsp(CLy,W);
        CLz_g=frsp(CLz,W);
        FreqRespX = vunpck(CLx_g);
        FreqRespY = vunpck(CLy_g);
        FreqRespZ = vunpck(CLz_g);

        normX=0; normY=0; normZ=0;
        for m=1:n
            normX = normX + norm(FreqRespX(50, m));
            normY = normY + norm(FreqRespY(50, m));
            normZ = normZ + norm(FreqRespZ(50, m));
        end
        savenorm(count, 1) = normX;
        savenorm(count, 2) = normY;
        savenorm(count, 3) = normZ;
        savenorm(count, 4) = normX + normY + normZ;
        
        count=count+1;
        
        if find(FreqRespX>=1) ~= 0
            if find(FreqRespY>=1) ~= 0
                if find(FreqRespZ>=1) ~= 0
                end
            end
        end
    end
end

drawnow 
close(h)
close( vidObj );