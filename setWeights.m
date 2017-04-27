%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Wn (Phase Lag Filter)                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=logspace(-2,4,100);
gain=2; f1=1; f2=10;
%     w1=2*pi*f1; w2=2*pi*f2; gain=gain*(w2/w1); num=[1 w1]; den=[1 w2];
    num=1; den=1;
    sys = tf(gain*num,den);
    magn = bode(sys,W); magn = squeeze(magn); magn = 20*log10(magn);
    wn = nd2sys(num,den,gain);
    % daug only allows upto 9 inputs. So divide it into 6 & 6 inputs
%     wns = daug(wn,wn,wn,wn,wn,wn);
%     Wn = daug(wns,wns);
wd=daug(wn,wn,wn);
Wd=daug(wd,wd);

%{%
figure
set(gcf, 'Name', 'Noise Weights');
semilogx(W,magn); grid on;
xlabel('Frequency [rad/s]'); ylabel('Gain [dB]'); legend('W_n');
%}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Wt (Phase Lag Filter)                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=logspace(-2,4,100);
gain=0.7; 
    f1=1; f2=10; w1=2*pi*f1; w2=2*pi*f2; gain=gain*(w2/w1);
    num=[1 w1]; den=[1 w2];
%     num=1;den=1;
    sys = tf(gain*num,den);
    magt = bode(sys,W); magt = squeeze(magt); magt = 20*log10(magt);
    wt = nd2sys(num,den,gain);
    Wt = daug(wt,wt,wt,wt);

%{%
figure
set(gcf, 'Name', 'Input Weights');
semilogx(W,magt); grid on;
xlabel('Frequency [rad/s]'); ylabel('Gain [dB]'); legend('W_t');
%}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Ws (MOST IMPORTANT)                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=logspace(-2,4,100);
Mag=zeros(length(W),length(X));
% -------------------------------- wsX ---------------------------------% 
gain=0.8; 
    % Phase Lead Filter
    f1=0.1; f2=0.3; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);
    numLead=[1 w1]; denLead=[1 w2];
    % Low Pass Filter
    f= 0.5; ze=0.01; w=2*pi*f; numLow=[0 0 w^2]; denLow=[1 2*ze*w w^2];
    num=conv(numLow,numLead); den=conv(denLow,denLead); 
    sys = tf(gain*num,den);
    magX = bode(sys,W); magX = squeeze(magX); magX = 20*log10(magX); 
    wsX = nd2sys(num,den,gain);
% -------------------------------- wsY ---------------------------------% 
gain=1;
    % Phase Lag Filter
    f1=0.1; f2=0.4;  w1=2*pi*f1; w2=2*pi*f2; numLag=[1 w2]; denLag=[1 w1];
    % Phase Lead Filter
    f1=0.1; f2=0.3; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);
    numLead=[1 w1]; denLead=[1 w2];
    % Band Elimination Filter
    f=0.5; ze=4; w=2*pi*f; numBef=[1 0 w^2]; denBef=[1 2*ze*w w^2];
    % Band Pass Filter
    f=0.5; ze=2; w=2*pi*f; numBand=[0 2*ze*w 0]; denBand=[1 2*ze*w w^2];
    % High Pass Filter
    f= 0.1; ze=0.6; w=2*pi*f; numHigh=[1 0 0]; denHigh=[1 2*ze*w w^2];
    % Low Pass Filter
    f= 0.5; ze=0.01; w=2*pi*f; numLow=[0 0 w^2]; denLow=[1 2*ze*w w^2];
    % Combining Both Phase Lag Filter and Band Pass Filter
    num=conv(numLow,numLead); den=conv(denLow,denLead); 
%     num=numLow; den=denLow;
    sys = tf(gain*num,den);
    magY = bode(sys,W); magY = squeeze(magY); magY = 20*log10(magY); 
    wsY = nd2sys(num,den,gain);
% -------------------------------- wsZ ---------------------------------% 
gain=0.1; f1=1;f2=10; w1=2*pi*f1; w2=2*pi*f2; 
    num=[1 w2]; den=[1 w1]; num=1;den=1;gain=1;
    sys = tf(gain*num,den);
    magZ = bode(sys,W); magZ = squeeze(magZ); magZ = 20*log10(magZ);
    wsZ = nd2sys(num,den,gain);
% -------------------------------- wsV ---------------------------------% 
gain=0.5; f1=0.1;f2=0.5;  w1=2*pi*f1; w2=2*pi*f2;
    num=[1 w2]; den=[1 w1];
    sys = tf(gain*num,den);
    magV = bode(sys,W); magV = squeeze(magV); magV = 20*log10(magV); 
    wsV = nd2sys(num,den,gain);
% -------------------------------- wsPh ---------------------------------% 
gain=0.1; f1=1;f2=10;  w1=2*pi*f1; w2=2*pi*f2;
    num=[1 w2]; den=[1 w1];num=1;den=1;gain=1;
    sys = tf(gain*num,den);
    magPh = bode(sys,W); magPh = squeeze(magPh); magPh = 20*log10(magPh); 
    wsPh = nd2sys(num,den,gain);
% -------------------------------- wsTh ---------------------------------% 
gain=0.1;     f1=1;f2=10;     w1=2*pi*f1; w2=2*pi*f2;
    num=[1 w2]; den=[1 w1];num=1;den=1;gain=1;
    sys = tf(gain*num,den);
    magTh = bode(sys,W); magTh = squeeze(magTh); magTh = 20*log10(magTh); 
    wsTh = nd2sys(num,den,gain);
% -------------------------------- wsPs ---------------------------------% 
gain=0.3;    f1=1;f2=10;     w1=2*pi*f1; w2=2*pi*f2;
    num=[1 w2]; den=[1 w1];num=1;den=1;gain=1;
    sys = tf(gain*num,den);
    magPs = bode(sys,W); magPs = squeeze(magPs); magPs = 20*log10(magPs); 
    wsPs = nd2sys(num,den,gain);
% -------------------------------- wsU ---------------------------------% 
% gain=1;     f1=1;f2=10;     w1=2*pi*f1; w2=2*pi*f2;
%     num=[1 w2]; den=[1 w1];
%     sys = tf(gain*num,den);
%     magU = bode(sys,W); magU = squeeze(magU); magU = 20*log10(magU); 
%     wsU = nd2sys(num,den,gain);
gain=0.3; f1=0.1;f2=0.5;  w1=2*pi*f1; w2=2*pi*f2;
    num=[1 w2]; den=[1 w1];
    sys = tf(gain*num,den);
    magU = bode(sys,W); magU = squeeze(magU); magU = 20*log10(magU); 
    wsU = nd2sys(num,den,gain);
% -------------------------------- wsW ---------------------------------% 
gain=0.1;     f1=1;f2=10;     w1=2*pi*f1; w2=2*pi*f2;
    num=[1 w2]; den=[1 w1];num=1;den=1;gain=1;
    sys = tf(gain*num,den);
    magW = bode(sys,W); magW = squeeze(magW); magW = 20*log10(magW); 
    wsW = nd2sys(num,den,gain);
% -------------------------------- wsP ---------------------------------% 
gain=0.1;     f1=1;f2=10;     w1=2*pi*f1; w2=2*pi*f2;
    num=[1 w2]; den=[1 w1];num=1;den=1;gain=1;
    sys = tf(gain*num,den);
    magP = bode(sys,W); magP = squeeze(magP); magP = 20*log10(magP); 
    wsP = nd2sys(num,den,gain);
% -------------------------------- wsQ ---------------------------------% 
gain=0.1;     f1=1;f2=10;     w1=2*pi*f1; w2=2*pi*f2;
    num=[1 w2]; den=[1 w1];num=1;den=1;gain=1;
    sys = tf(gain*num,den);
    magQ = bode(sys,W); magQ = squeeze(magQ); magQ = 20*log10(magQ); 
    wsQ = nd2sys(num,den,gain);
% -------------------------------- wsR ---------------------------------% 
gain=0.1;     f1=1;f2=10;     w1=2*pi*f1; w2=2*pi*f2;
    num=[1 w2]; den=[1 w1];num=1;den=1;gain=1;
    sys = tf(gain*num,den);
    magR = bode(sys,W); magR = squeeze(magR); magR = 20*log10(magR); 
    wsR = nd2sys(num,den,gain);
% Integrate all weights into one, as daug only allows upto 9 inputs
Ws = daug(wsX,wsY,wsZ,wsU,wsV,wsW);
%{
num=1;den=1;gain=1; ws=nd2sys(num,den,gain);
wsZ=ws;wsW=ws;wsPh=ws;wsTh=ws;wsPs=ws;wsP=ws;wsQ=ws;wsR=ws;
ws1 = daug(wsX,wsY,wsZ,wsU,wsV,wsW);
ws2 = daug(wsPh,wsTh,wsPs,wsP,wsQ,wsR);
WsAll = daug(ws1,ws2);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   Plot                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot of Performance Weighting Function
%{
figure
set(gcf, 'Name', 'Performance Weighting Function');
semilogx(W,magX,W,magY,W,magZ, W,magU, W,magV, W,magW, W,magPh, W,magTh, W,magPs, W,magP,W,magQ,W,magR);
xlabel('Frequency [rad/s]'); ylabel('Gain [dB]');
legend('{\itx}','{\ity}','{\itz}','{\itu}','{\itv}','{\itw}','\phi','\theta','\psi','{\itp}','{\itq}','{\itr}'); grid on; 
%}
figure
set(gcf, 'Name', 'Performance Weighting Function');
semilogx(W/(2*pi),magX, W/(2*pi),magY, W/(2*pi),magZ, W/(2*pi),magU, W/(2*pi),magV,  W/(2*pi),magW);
xlabel('Frequency [rad/s]'); ylabel('Gain [dB]');
legend('{\itW_x}','{\itW_y}','{\itW_z}','{\itW_u}','{\itW_v}','{\itW_w}'); grid on; xlim([10^(-2) 10^(1)]);ylim([-20 60]);

% Plot of Inverse of Performance Weighting Function (sensitivity)
%{
figure('Position',[1921 97 1280 907])
set(gcf, 'Name', 'Sensitivity');
% semilogx(W,-magX, W,-magY, W,-magZ, W,-magPh, W,-magTh, W,-magPs);
semilogx(W,-magX, W,-magY, W,-magZ, W,-magV, W,-magPh, W,-magTh, W,-magPs);
xlabel('Frequency [rad/s]'); ylabel('Gain [dB]');
legend('x','y','z','v','\phi','\theta','\psi'); grid on; 
%}

Mag(:,1)=magX; Mag(:,2)=magY; Mag(:,3)=magZ;
Mag(:,4)=magU; Mag(:,5)=magV; Mag(:,6)=magW;
Mag(:,7)=magPh; Mag(:,8)=magTh; Mag(:,9)=magPs;
Mag(:,10)=magP; Mag(:,11)=magQ; Mag(:,12)=magR;
