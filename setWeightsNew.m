%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Wt (Phase Lead Filter)                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ----------------------------- setup ----------------------------------%
W=logspace(-1,2,100);
% Calculating a, which is Phut=a*P, where a^-1 is stable
Anum1=[1 1]; Aden1=[1 0];
a1=tf(Anum1,Aden1);
Anum2=conv(Anum1,Anum1); Aden2=conv(Aden1,Aden1);
Anum3=conv(Anum1,Anum2); Aden3=conv(Aden1,Aden2);
Anum4=conv(Anum1,Anum3); Aden4=conv(Aden1,Aden3);
% Calculating which s^0 (P stands for pole)
Pnum1=[1]; Pden1=[1 0];
Pnum2=conv(Pnum1,Pnum1); Pden2=conv(Pden1,Pden1);
Pnum3=conv(Pnum1,Pnum2); Pden3=conv(Pden1,Pden2);
Pnum4=conv(Pnum1,Pnum3); Pden4=conv(Pden1,Pden3);
% -------------------------------- x ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % BODE DIAGRAM
    sys = tf(gain*num,den); magt = bode(sys,W); magt = squeeze(magt); magt = 20*log10(magt);
    figure; set(gcf, 'Name', 'Input Weights'); semilogx(W,magt); grid on;
    xlabel('Frequency [rad/s]'); ylabel('Gain [dB]'); legend('W_t');xlim([10^(-1) 10^(2)]);ylim([-20 30]);
    
    % Wt_hut = Wt/a
    num=conv(num,Aden4); den=conv(den,Anum4);
    msysx = nd2sys(num,den,gain);
% -------------------------------- y ------------------------------------%
msysy=msysx;
% -------------------------------- z ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden2); den=conv(den,Anum2);
    msysz = nd2sys(num,den,gain);
% -------------------------------- u ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden3); den=conv(den,Anum3);
    msysu = nd2sys(num,den,gain);
% -------------------------------- v ------------------------------------%
msysv=msysu;
% -------------------------------- w ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden1); den=conv(den,Anum1);
    msysw = nd2sys(num,den,gain);
% -------------------------------- phi ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden2); den=conv(den,Anum2);
    msysphi = nd2sys(num,den,gain);
% -------------------------------- theta ------------------------------------%
msystheta=msysphi;
% -------------------------------- psi ------------------------------------%
msyspsi=msysphi;
% -------------------------------- p ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden1); den=conv(den,Anum1);
    msysp = nd2sys(num,den,gain);
% -------------------------------- q ------------------------------------%
msysq=msysp;
% -------------------------------- r ------------------------------------%
msysr=msysp;
% ------------------------------ total ----------------------------------%
Wt=daug(daug(msysx,msysy,msysz), daug(msysu,msysv,msysw), daug(msysphi,msystheta,msyspsi), daug(msysp,msysq,msysr));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Ws (MOST IMPORTANT)                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------- x ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    % BODE DIAGRAM
    sys = tf(gain*num,den); magX = bode(sys,W); magX = squeeze(magX); magX = 20*log10(magX); wsX = nd2sys(num,den,gain);
    figure; set(gcf, 'Name', 'Performance Weighting Function'); semilogx(W,magX);
    xlabel('Frequency [rad/s]'); ylabel('Gain [dB]'); legend('{\itW_x}'); grid on; xlim([10^(-1) 10^(2)]);ylim([-20 30]);
    
    % Ws_hut = Ws/a^0
    num=conv(num,Pnum4); den=conv(den,Pden4);
    msysx = nd2sys(num,den,gain);
% -------------------------------- y ------------------------------------%
msysy=msysx;
% -------------------------------- z ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum2); den=conv(den,Pden2);
    msysz = nd2sys(num,den,gain);
% -------------------------------- u ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum3); den=conv(den,Pden3);
    msysu = nd2sys(num,den,gain);
% -------------------------------- v ------------------------------------%
msysv=msysu;
% -------------------------------- w ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum1); den=conv(den,Pden1);
    msysw = nd2sys(num,den,gain);
% -------------------------------- phi ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum2); den=conv(den,Pden2);
    msysphi = nd2sys(num,den,gain);
% -------------------------------- theta ------------------------------------%
msystheta=msysphi;
% -------------------------------- psi ------------------------------------%
msyspsi=msysphi;
% -------------------------------- p ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum1); den=conv(den,Pden1);
    msysp = nd2sys(num,den,gain);
% -------------------------------- q ------------------------------------%
msysq=msysp;
% -------------------------------- r ------------------------------------%
msysr=msysp;
% ------------------------------ total ----------------------------------%
Ws=daug(daug(msysx,msysy,msysz), daug(msysu,msysv,msysw), daug(msysphi,msystheta,msyspsi), daug(msysp,msysq,msysr));