%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Amplitude                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------- Nausea --------------------------------%
[vrdata,txt,raw]=xlsread('SSQ_Scores_total.xlsx','SSQ_total','M30:Q37');
Amp=vrdata(:,1);
high_straight=vrdata(:,2);
high_side=vrdata(:,3);
low_straight=vrdata(:,4);
low_side=vrdata(:,5);

figure
plot(Amp(~isnan(high_straight)),high_straight(~isnan(high_straight)),'o-',...
    Amp(~isnan(high_side)),high_side(~isnan(high_side)),'o-',...
    Amp(~isnan(low_straight)),low_straight(~isnan(low_straight)),'o-',...
    Amp(~isnan(low_side)),low_side(~isnan(low_side)),'o-');
xlabel('Amplitude [mm]');ylabel('Nausea SSQ Score');legend(txt);grid on;
% ----------------------------- Oculomotor ------------------------------%
[vrdata,txt,raw]=xlsread('SSQ_Scores_total.xlsx','SSQ_total','M38:Q45');
Amp=vrdata(:,1);
high_straight=vrdata(:,2);
high_side=vrdata(:,3);
low_straight=vrdata(:,4);
low_side=vrdata(:,5);

figure
plot(Amp(~isnan(high_straight)),high_straight(~isnan(high_straight)),'o-',...
    Amp(~isnan(high_side)),high_side(~isnan(high_side)),'o-',...
    Amp(~isnan(low_straight)),low_straight(~isnan(low_straight)),'o-',...
    Amp(~isnan(low_side)),low_side(~isnan(low_side)),'o-');
xlabel('Amplitude [mm]');ylabel('Oculomotor SSQ Score');legend(txt);grid on;
% ----------------------------- Distortion ------------------------------%
[vrdata,txt,raw]=xlsread('SSQ_Scores_total.xlsx','SSQ_total','M46:Q53');
Amp=vrdata(:,1);
high_straight=vrdata(:,2);
high_side=vrdata(:,3);
low_straight=vrdata(:,4);
low_side=vrdata(:,5);

figure
plot(Amp(~isnan(high_straight)),high_straight(~isnan(high_straight)),'o-',...
    Amp(~isnan(high_side)),high_side(~isnan(high_side)),'o-',...
    Amp(~isnan(low_straight)),low_straight(~isnan(low_straight)),'o-',...
    Amp(~isnan(low_side)),low_side(~isnan(low_side)),'o-');
xlabel('Amplitude [mm]');ylabel('Distortion SSQ Score');legend(txt);grid on;
% ------------------------------- Total ---------------------------------%
[vrdata,txt,raw]=xlsread('SSQ_Scores_total.xlsx','SSQ_total','M54:Q61');
Amp=vrdata(:,1);
high_straight=vrdata(:,2);
high_side=vrdata(:,3);  
low_straight=vrdata(:,4);
low_side=vrdata(:,5);

figure
plot(Amp(~isnan(high_straight)),high_straight(~isnan(high_straight)),'o-',...
    Amp(~isnan(high_side)),high_side(~isnan(high_side)),'o-',...
    Amp(~isnan(low_straight)),low_straight(~isnan(low_straight)),'o-',...
    Amp(~isnan(low_side)),low_side(~isnan(low_side)),'o-');
xlabel('Amplitude [mm]');ylabel('Total SSQ Score');legend(txt);grid on;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Frequency                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------- Nausea --------------------------------%
[vrdata,txt,raw]=xlsread('SSQ_Scores_total.xlsx','SSQ_total','M3:Q8');
Amp=vrdata(:,1);
high_straight=vrdata(:,2);
high_side=vrdata(:,3);
low_straight=vrdata(:,4);
low_side=vrdata(:,5);
figure
semilogx(Amp(~isnan(high_straight)),high_straight(~isnan(high_straight)),'o-',...
    Amp(~isnan(high_side)),high_side(~isnan(high_side)),'o-',...
    Amp(~isnan(low_straight)),low_straight(~isnan(low_straight)),'o-',...
    Amp(~isnan(low_side)),low_side(~isnan(low_side)),'o-');
xlabel('Frequency [Hz]');ylabel('Nausea SSQ Score');legend(txt);grid on;
% ----------------------------- Oculomotor ------------------------------%
[vrdata,txt,raw]=xlsread('SSQ_Scores_total.xlsx','SSQ_total','M9:Q14');
Amp=vrdata(:,1);
high_straight=vrdata(:,2);
high_side=vrdata(:,3);
low_straight=vrdata(:,4);
low_side=vrdata(:,5);
figure
semilogx(Amp(~isnan(high_straight)),high_straight(~isnan(high_straight)),'o-',...
    Amp(~isnan(high_side)),high_side(~isnan(high_side)),'o-',...
    Amp(~isnan(low_straight)),low_straight(~isnan(low_straight)),'o-',...
    Amp(~isnan(low_side)),low_side(~isnan(low_side)),'o-');
xlabel('Frequency [Hz]');ylabel('Oculomotor SSQ Score');legend(txt);grid on;
% ----------------------------- Distortion ------------------------------%
[vrdata,txt,raw]=xlsread('SSQ_Scores_total.xlsx','SSQ_total','M15:Q20');
Amp=vrdata(:,1);
high_straight=vrdata(:,2);
high_side=vrdata(:,3);
low_straight=vrdata(:,4);
low_side=vrdata(:,5);
figure
semilogx(Amp(~isnan(high_straight)),high_straight(~isnan(high_straight)),'o-',...
    Amp(~isnan(high_side)),high_side(~isnan(high_side)),'o-',...
    Amp(~isnan(low_straight)),low_straight(~isnan(low_straight)),'o-',...
    Amp(~isnan(low_side)),low_side(~isnan(low_side)),'o-');
xlabel('Frequency [Hz]');ylabel('Distortion SSQ Score');legend(txt);grid on;
% ------------------------------- Total ---------------------------------%
%%
[vrdata,txt,raw]=xlsread('SSQ_Scores_total.xlsx','SSQ_total','Q21:U26');
Amp=vrdata(:,1);
high_straight=vrdata(:,2);
high_side=vrdata(:,3);
low_straight=vrdata(:,4);
low_side=vrdata(:,5);
figure
semilogx(Amp(~isnan(high_straight)),high_straight(~isnan(high_straight)),'o-',...
    Amp(~isnan(high_side)),high_side(~isnan(high_side)),'o-',...
    Amp(~isnan(low_straight)),low_straight(~isnan(low_straight)),'o-',...
    Amp(~isnan(low_side)),low_side(~isnan(low_side)),'o-');
xlabel('Frequency [Hz]');ylabel('Total SSQ Score');legend(txt);grid on; ylim([0 40]);