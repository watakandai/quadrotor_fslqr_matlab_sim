%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   * represents out
%   O represents in
%          ________________Wt__________________________________________>                                               
%         |                                     n         
%         |                                     |       Ws ------------> z
%         |                                     Wn      |   
%   U     |             integral      x     y   V       |  
%  -------O-*---B-- ->O----> S ----*-----C----> O ------*--------->*--> y'
%  |        |         |            |                               |
%  |        |         <---- A <----                               _|__ Zi
%  |        --------------------------------------- Wi ----------/ | 
%  -<--------------------------- K <--------------------------------
%                                                   y
%
% General Plant (for H infinity)1
%       (d/dt)Xg  = Ag*Xg + B1*Wg    + B2*U
%       Zg        = C1*Xg + (D11*Wg) + D12*U
%       y         = C2*Xg + D21*Wg   + (D22*U)
%
%   where:      X = state;          % [x,y,z,u,v,w,phi,th,psi,p,q,r]
%               U = input;          % [f,tx,ty,tz]
%               D = disturbance;    % [fwx,fwy,fwz,twx,twy,tw]
%               Y = output;         % Leave it for now. Depends on sensors
%               Z = Output to curb  % [y v phi]
%               Xg = Augmented States % [X y v phi U]
%               Zi = u
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PLANT FOR H_INFINITY CONTROLLER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Setup Open Loop System                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
systemnames = ' P Ws Wt Wn';
inputvar =  '[ dist{4}; noise{12}; control{4} ]';
outputvar = '[ Ws; Wt; -P-Wn]';     % Ws=7, Wt=4
input_to_P = '[ control + dist ]';
input_to_Ws = '[ P(1,2,3,5,7,8,9) ]';
input_to_Wt = '[ control ]';
input_to_Wn = '[ noise ]';
sysoutname = 'G';
cleanupsysic = 'yes';
sysic;
[K, CL, gamma] = hinfsyn(G,12,4,1,10,0.01,2);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Setup Closed Loop System                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
systemnames = ' P Wn1 Wn2';
inputvar =  '[ ref{3}; noise{12}; dist{6}; control{4} ]';
outputvar = '[ P; control; ref-P(1:3)-Wn1; -P(4:12)-Wn2 ]';
input_to_P = '[ dist; control]';
input_to_Wn1 = '[ noise(1:3) ]';
input_to_Wn2 = '[ noise(4:12) ]';
sysoutname = 'Gclosed';
cleanupsysic = 'yes';
sysic;
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Try every combination                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
n=length(X);
Ns=1:n;
count=1;
Freq=[0.01 0.05 0.1 0.5 1.0 5.0 10 50];
Noise = zeros(n,1);
%step
ref=step_tr(0,1,dt,t_end);
stepRef=abv(ref,ref,ref);
stepDist=zeros(size(Dd,2),1);
% Sin Input
mag=2;
sinRef=zeros(3,1);
% setting waitbar 
h=waitbar(0,'Name','Calculating Every Combinations','CreateCancelBtn'); allComb=0; countComb=0;
for i=1:n
    allComb=allComb+size(nchoosek(Ns,i),1);
end
for i=1:n
    Indexes=nchoosek(Ns,i);
    numComb=size(Indexes,1);
    for j=1:numComb
        countComb=countComb+1;
        waitbar(countComb/allComb,h,sprintf('Nth:%i, Combo:%i, Loops:%i/%i',i,numComb,countComb,allComb));
        Dslct=zeros(1,n);
        index=Indexes(j,:);
        for k=1:i
            elem=index(k);
            Dslct(k,elem)=1;
        end
        Aslct=eye(i); Bslct=zeros(i,n); Cslct=zeros(i,i); Slct = pck(-Aslct,Bslct,Cslct,Dslct);
        try
            Ws=sel(WsAll,index,index);
%             systemnames = ' P Ws Wt Wn Slct';
            systemnames = ' P Ws Wt Wn1 Wn2 Slct';
            inputvar =  '[ noise{12}; dist{6}; control{4} ]';
%             outputvar = '[ Ws; Wt; -P(1:3)-Wn; -P(4:12)]';     % Ws=7, Wt=4
            outputvar = '[ Ws; Wt; -P(1:3)-Wn1; -P(4:12)-Wn2]';     % Ws=7, Wt=4
            input_to_P = '[ dist; control ]';
            input_to_Slct = '[ P ]';
            input_to_Ws = '[ Slct ]';
            input_to_Wt = '[ control ]';
            input_to_Wn1 = '[ noise(1:3) ]';
            input_to_Wn2 = '[ noise(4:12) ]';
            sysoutname = 'G';
            cleanupsysic = 'yes';
            sysic;
            [K, CL, gamma] = hinfsyn(G,12,4,1,10,0.01,2);
        catch
            continue
        end
        if isempty(K) % if empty, do nothing
        else
            [Actr,Bctr,Cctr,Dctr]=unpck(K);
            for k=1:i
                combinations(count,k)=index(1,k);
            end
            clp_ic = starp(Gclosed,K,12,4);
            for x=1:length(X)
                % Closed Loop Frequency Response
                sense=sel(clp_ic,x,[4:21]); sense_g=frsp(sense,W);
                dataSense=vunpck(vnorm(sense_g)); dataSense=20*log10(dataSense);
                Sense(:,x,count)=dataSense;
                % Closed Loop Time Response
                % step input
                stepResponse=trsp(clp_ic,abv(stepRef,Noise,stepDist),t_end,dt);
                eachResponse=vunpck(sel(stepResponse,x,1));
                saveStepState(:,x,count)=eachResponse;
                % sin input for different frequency
                for f=1:length(Freq)
                    dist=sin_tr(2*pi*Freq(f),mag,dt,t_end);
                    sinDist=abv(dist,dist,dist,0,0,0);
                    sinResponse=trsp(clp_ic,abv(sinRef,Noise,sinDist),t_end,dt);
                    eachResponse=vunpck(sel(sinResponse,x,1));
                    saveSinState(:,x,count,f)=eachResponse;
                    saveSinRms(:,x,count,f)=rms(eachResponse);
                end
            end
            count=count+1;
        end
    end
end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Load Possible Combinations                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
n=length(X);
Freq=[0.01 0.05 0.1 0.5 1.0 5.0 10 50];
% load('combinations.mat');
numComb=size(combinations,1);
Sense=zeros(length(W),n,numComb);
Noise = zeros(n,1);
% Step Input 
saveStepState=zeros(length(T),n,numComb);
ref=step_tr(0,1,dt,t_end);
stepRef=abv(ref,ref,ref);
stepDist=zeros(size(Dd,2),1);
% Sin Input
mag=10;
saveSinState=zeros(length(T),n,numComb,length(Freq));
saveSinRms=zeros(1,n,numComb,length(Freq));
sinRef=zeros(3,1);
h=waitbar(0,'Please wait...')
for j=1:numComb
    waitbar(j/numComb,h,sprintf('Loops:%i/%i',j,numComb));
    Dslct=zeros(1,n);
    index=combinations(j,:);
    index(:,find(index(1,:)==0))=[];
    i=length(index);
    for k=1:i
        elem=index(k);
        Dslct(k,elem)=1;
    end
    Aslct=eye(i); Bslct=zeros(i,n); Cslct=zeros(i,i); Slct = pck(-Aslct,Bslct,Cslct,Dslct);
    Ws=sel(WsAll,index,index);
    systemnames = ' P Ws Wt Wn1 Wn2 Slct';
    inputvar =  '[ noise{12}; dist{6}; control{4} ]';
    outputvar = '[ Ws; Wt; -P(1:3)-Wn1; -P(4:12)-Wn2]';     % Ws=7, Wt=4
    input_to_P = '[ dist; control ]';
    input_to_Slct = '[ P ]';
    input_to_Ws = '[ Slct ]';
    input_to_Wt = '[ control ]';
    input_to_Wn1 = '[ noise(1:3) ]';
    input_to_Wn2 = '[ noise(4:12) ]';
    sysoutname = 'G';
    cleanupsysic = 'yes';
    sysic;
    [K, CL, gamma] = hinfsyn(G,12,4,1,10,0.01,2,'DISPLAY','off');
    [Actr,Bctr,Cctr,Dctr]=unpck(K);
    clp_ic = starp(Gclosed,K,12,4);
    for x=1:length(X)
        % Closed Loop Frequency Response
        sense=sel(clp_ic,x,[4:21]); sense_g=frsp(sense,W);
        dataSense=vunpck(vnorm(sense_g)); dataSense=20*log10(dataSense);
        Sense(:,x,j)=dataSense;
        % Closed Loop Time Response
        % step input
        stepResponse=trsp(clp_ic,abv(stepRef,Noise,stepDist),t_end,dt);
        eachResponse=vunpck(sel(stepResponse,x,1));
        saveStepState(:,x,j)=eachResponse;
        % sin input for different frequency 
        for f=1:length(Freq)
            dist=sin_tr(2*pi*Freq(f),mag,dt,t_end);
            sinDist=abv(dist,dist,dist,0,0,0);
            sinResponse=trsp(clp_ic,abv(sinRef,Noise,sinDist),t_end,dt);
            eachResponse=vunpck(sel(sinResponse,x,1));
            saveSinState(:,x,j,f)=eachResponse;
            saveSinRms(:,x,j,f)=rms(eachResponse);
        end
    end
end
%}


close(h)