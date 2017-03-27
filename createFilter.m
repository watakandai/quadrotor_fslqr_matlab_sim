W=logspace(-2,4,100);
F=W/pi/2;
%% Low, High, Band, Bef Filter  (1st Order Filter)
% Low Pass --------------------------------------------------------------
gain=100; f=0.5; ze=0.01; w=2*pi*f; numLow=[0 0 w^2]; denLow=[1 2*ze*w w^2];
    [A_low,B_low,C_low,D_low]=tf2ss(gain*numLow,denLow);
    mag_low=bode(tf(gain*numLow,denLow),W); mag_low=20*log10(mag_low);
% High Pass --------------------------------------------------------------
gain=1; f=0.1; ze=0.6; w=2*pi*f; numHigh=[1 0 0]; denHigh=[1 2*ze*w w^2];
    [A_high,B_high,C_high,D_high] = tf2ss(gain*numHigh,denHigh);
    mag_high=bode(tf(gain*numHigh,denHigh),W); mag_high=20*log10(mag_high);
% Band pass --------------------------------------------------------------
gain=1; f=0.5; ze=2; w=2*pi*f; numBand=[0 2*ze*w 0]; denBand=[1 2*ze*w w^2];
%     numBand = K_band*[1 80  w_band^2]; denBand = [1 8 w_band^2];
    [A_band,B_band,C_band,D_band]=tf2ss(gain*numBand,denBand);
    mag_band=bode(tf(gain*numBand,denBand),W); mag_band=20*log10(mag_band);
% Band elimination filter  -----------------------------------------------
gain=1; f=0.5; ze=4; w=2*pi*f; numBef=[1 0 w^2]; denBef=[1 2*ze*w w^2];
    [A_bef,B_bef,C_bef,D_bef]=tf2ss(gain*numBef,denBef);
    mag_bef=bode(tf(gain*numBef,denBef),W); mag_bef=-20*log10(mag_bef);

figure('Position',[1921 97 1280 907])
semilogx(W,mag_low(1,:), W,mag_high(1,:), W,mag_band(1,:), W, mag_bef(1,:))
xlabel('Frequency [rad/s]'); ylabel('Gain [dB]');
legend('low','high','band','bef'); grid on;
% axis([10^(-2),10^3,-100,10]);
%% Phase Lead/Lag Filter (1st Order Filter)
% http://naosite.lb.nagasaki-u.ac.jp/dspace/bitstream/10069/35886/30/Chapter%2010.pdf
% Phase Lead Filter
% (w2/w1)*(s+w1 / s+w2)       where w1<w2
gain=1; f1=0.1; f2=0.3; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);
    numLead=[1 w1]; denLead=[1 w2]; sysLead = tf(numLead,denLead);
    [A_lead,B_lead,C_lead,D_lead] = tf2ss(numLead,denLead);
    mag_lead = bode(sysLead,W); mag_lead = squeeze(mag_lead); mag_lead = 20*log10(mag_lead);
% Phase Lag Filter
% s+w2 / s+w1       where w1<w2
gain=1; f1=0.1; f2=0.4;  w1=2*pi*f1; w2=2*pi*f2; 
    numLag=[1 w2]; denLag=[1 w1]; sysLag = tf(numLag,denLag); 
    [A_lag,B_lag,C_lag,D_lag] = tf2ss(numLag,denLag); 
    mag_lag = bode(sysLag,W); mag_lag = squeeze(mag_lag); mag_lag = 20*log10(mag_lag); 
figure('Position',[1921 97 1280 907])
semilogx(W, mag_lead, W, mag_lag)
xlabel('Frequency [rad/s]'); ylabel('Gain [dB]'); 
legend('lead','lag'); grid on;

