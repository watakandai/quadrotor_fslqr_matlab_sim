X = X0;
U = U0;
Z = 0;
Xaltref = Xref(3);
% boxes to store data
T_data = T;                                    % time t
Xlqr_data = zeros(length(X), length(T_data));     % state x
Ulqr_data = zeros(length(U), length(T_data));     % input u to the motor
PhiRefLqr_data = zeros(1, length(T_data));
ThRefLqr_data = zeros(1, length(T_data));
phi_ref=0;
th_ref=0;

Vwind = zeros(length(Au)+length(Av)+length(Aw), 1);
Vw = zeros(3,1);
Vwlqr_data=zeros(length(Vw), length(T_data));

for t=1:(length(T))     % t=0 ~ t=t_end
% Save Data
    T_data(:,t)  = t*dt;                        % time  t
    Xlqr_data(:,t)  = X;                         % state x
    Ulqr_data(:,t) = U;                            % input u
    Vwlqr_data(:,t) = Vw ;
    PhiRefLqr_data(:,t) = phi_ref;
    ThRefLqr_data(:,t) = th_ref;

    % ------------------------- For Plant ---------------------------%
    % Sign Disturbance 
    if flagSine==1
        if t < (1/freq/dt/2)
            vw = Amp * sin(2*pi*freq*t*dt);
            Vw=[vw vw vw]';
        else
            Vw=[0 0 0]';
        end
    elseif flagSine==111
        vw = Amp * sin(2*pi*freq*t*dt);
        Vw=[vw vw vw]';
    elseif flagSine==0
        Vw=[0 0 0]';
    elseif flagSine==3
        Wv = wgn(3,1,1);
        dVwind1 = getdVwind(Vwind, Wv, Au,Av,Aw,Bu,Bv,Bw)*dt;
        dVwind2 = getdVwind(Vwind+dVwind1/2, Wv, Au,Av,Aw,Bu,Bv,Bw)*dt;
        dVwind3 = getdVwind(Vwind+dVwind2/2, Wv, Au,Av,Aw,Bu,Bv,Bw)*dt;
        dVwind4 = getdVwind(Vwind+dVwind3, Wv, Au,Av,Aw,Bu,Bv,Bw)*dt;
        Vwind = Vwind + (dVwind1+2*dVwind2+2*dVwind3+dVwind4)/6;
        Vw = Cwind*Vwind;
    end

    % get Values from the Raw Sensor
    phi=X(7);
    th=X(8);
    psi=X(9);
    % Process the data with the Oberserver
    
    % Altitude Controller
    % Determine The Altitude Input
%     dXalt1 = getdX(Xalt, Ualt_virt, Aerror, Balt)*dt;
%     dXalt2 = getdX(Xalt+dXalt1/2, Ualt_virt, Aerror, Balt)*dt;
%     dXalt3 = getdX(Xalt+dXalt2/2, Ualt_virt, Aerror, Balt)*dt;
%     dXalt4 = getdX(Xalt+dXalt3, Ualt_virt, Aerror, Balt)*dt;
%     Xalt = Xalt+(dXalt1+2*dXalt2+2*dXalt3+dXalt4)/6; 
    Ualt_virt = Kz*([X(3); X(6); Xref(3)-X(3)]);                %=> Error State Need to be Integrated
    Ualt = m*(Ualt_virt+g)/(cos(phi)*cos(psi));
    
    % Position Controller
    % Determine the Position Input -> Phi_ref & Theta_ref
    Bpos = [0; Ualt/m; 0];
    Kx = lqr(Aerror, Bpos, diag([100, 10, 1]), 1);
%     dXposx1 = getdX(Xposx, Ux, Aerror, Bpos)*dt;
%     dXposx2 = getdX(Xposx+dXposx1/2, Ux, Aerror, Bpos)*dt;
%     dXposx3 = getdX(Xposx+dXposx2/2, Ux, Aerror, Bpos)*dt;
%     dXposx4 = getdX(Xposx+dXposx3, Ux, Aerror, Bpos)*dt;
%     Xposx = Xposx+(dXposx1 + 2*dXposx2 + 2*dXposx3 + dXposx4)/6; 
    Ux = Kx*([X(1); X(4); Xref(1)-X(1)]);
    Ky=Kx;
%     dXposy1 = getdX(Xposy, Uy, Aerror, Bpos)*dt;
%     dXposy2 = getdX(Xposy+dXposy1/2, Uy, Aerror, Bpos)*dt;
%     dXposy3 = getdX(Xposy+dXposy2/2, Uy, Aerror, Bpos)*dt;
%     dXposy4 = getdX(Xposy+dXposy3, Uy, Aerror, Bpos)*dt;
%     Xposy = Xposx+(dXposy1 + 2*dXposy2 + 2*dXposy3 + dXposy4)/6; 
    Uy = Ky*([X(2); X(5); Xref(2)-X(2)]);
    
    % Calc Phi_ref, Theta_ref
    phi_ref = Uy;
    th_ref = Ux;
%     phi_ref = asin((cos(phi)*sin(th)*sin(psi)-Uy)/cos(psi));
%     th_ref = asin((Ux-sin(phi)*sin(psi))/(cos(phi)*cos(psi)));
    
    % Atitude Controller
%     dXatt1 = getdX(Xatt, Uatt, Aerror, Batt);
%     dXatt2 = getdX(Xatt+dXatt1/2, Uatt, Aerror, Batt);
%     dXatt3 = getdX(Xatt+dXatt2/2, Uatt, Aerror, Batt);
%     dXatt4 = getdX(Xatt+dXatt3, Uatt, Aerror, Batt);
%     Xatt = Xatt + (dXatt1 + 2*dXatt2 + 2*dXatt3 + dXatt4)/6;
    Utx = Kphi*([X(7); X(10); phi_ref-phi]);
    Uty = Kth*([X(8); X(11); th_ref-th]);
    Utz = Kpsi*([X(9); X(12); Xref(4)-psi]);
    
    U = [Ualt; Utx; Uty; Utz];
    
    % NonlinearDynamics (Equation of Motion)
    dX1 = getNonlineardX_earth(X, U, Vw)*dt;
    dX2 = getNonlineardX_earth(X+dX1/2, U, Vw)*dt;
    dX3 = getNonlineardX_earth(X+dX2/2, U, Vw)*dt;
    dX4 = getNonlineardX_earth(X+dX3, U, Vw)*dt;  
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;
end
