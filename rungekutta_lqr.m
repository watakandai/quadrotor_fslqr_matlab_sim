X = X0;
U = U0;
Z = 0;
% boxes to store data
T_data = T;                                    % time t
Xlqr_data = zeros(length(X), length(T_data));     % state x
Ulqr_data = zeros(length(U), length(T_data));     % input u to the motor
PhiRefLqr_data = zeros(1, length(T_data));
ThRefLqr_data = zeros(1, length(T_data));
phi_ref_now=0; phi_ref=0;
th_ref_now=0; th_ref=0;
Ex=0; Ey=0; Ez=0; 
Ephi_data=zeros(1, length(T_data));
Eth_data=zeros(1, length(T_data));
Epsi_data=zeros(1, length(T_data));
Ephi=0; Eth=0; Epsi=0; 
Ee=zeros(size(Xref,1),1);
Ee_data=zeros(size(Xref,1),length(T_data));

Vx = zeros(length(Au)+length(Av)+length(Aw), 1);
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
    Ephi_data(:,t) = Ephi;
    Eth_data(:,t) = Eth;
    Epsi_data(:,t) = Epsi;
    Ee_data(:,t) = Ee;
    

    % ------------------------- For Plant ---------------------------%
    [Vw, Vx] = setDisturbance(flagWind, Vx, Au, Av, Aw, Bu, Bv, Bw, Cwind, t, dt, freq, Amp, wind_stop_time);
  
    %------------- Full State Linear FeedBack
    %{%
    Ee = Ee + (Xref-Ce*X)*dt;
%     U = Ke*X + Ge*Ee + FFe*Xref + FFinie*X0 + [m*g;0;0;0];
    U = Ke*X + [m*g;0;0;0];
    Xerr = [X(1)-Xref(1);
            X(2)-Xref(2);
            X(3)-Xref(3);
            X(4); X(5); X(6); X(7); X(8); 
            X(9)-Xref(4); 
            X(11); X(11); X(12)];
%     U = -K_lqr*Xerr + [m*g; 0; 0; 0];
    %}
    
    %-------------- Cascaded System FeedBack
    %{
    % Altitude Controller
    % Determine The Altitude Input
%     Ualt = m/(cos(phi)*cos(psi)) * (g+Ualt_virt);

    Ez = Ez + (Xref(3)-X(3))*dt;
    Ualt_virt = Kz*[X(3);X(6)] + Gz*Ez + FFz*Xref(3) + FFinitz*[X0(3);X0(6)];
    
    Ualt = m*(g+Ualt_virt);
    
    % Position Controller
    % Determine the Position Input -> Phi_ref & Theta_ref
    Ex = Ex + (Xref(1)-X(1))*dt;
    Ux = Kxy*[X(1);X(4)] + Gxy*Ex + FFxy*Xref(1) + FFinitxy*[X0(1);X0(4)];
    Ey = Ey + (Xref(2)-X(2))*dt; 
    Uy = Kxy*[X(2);X(5)] + Gxy*Ey + FFxy*Xref(2) + FFinitxy*[X0(2);X0(5)];

    % Calc Phi_ref, Theta_ref
    phi_ref_now = -Uy;
    th_ref_now = Ux;
    phi_deg = phi_ref_now*180/pi;
    th_deg = th_ref_now*180/pi;
%     phi_ref = asin((cos(phi)*sin(th)*sin(psi)-Uy)/cos(psi));
%     th_ref = asin((Ux-sin(phi)*sin(psi))/(cos(phi)*cos(psi)));

%     phi_ref = 0.9*phi_ref + 0.1*phi_ref_now;
%     th_ref = 0.9*th_ref + 0.1*th_ref_now;

    if Ux>0.2
        th_ref=0.2;
    elseif Ux<-0.2
        th_ref=-0.2;
    else
        th_ref=0;
    end
    if Uy>0.1
        phi_ref=-0.1;
    elseif Uy<-0.1
        phi_ref=0.1;
    else
        phi_ref=0;
    end
    
    %{
    if phi_ref > 0.523599
        phi_ref = 0.523599;
    elseif phi_ref < -0.523599
        phi_ref = -0.523599;
    end
    if th_ref > 0.523599
        th_ref = 0.523599;
    elseif th_ref < -0.523599
        th_ref = -0.523599;
    end
    %}
    
    %{%
    % Atitude Controller
    phi=X(7); th=X(8); psi=X(9);
    Ephi = Ephi + (phi_ref-phi)*dt;
    Eth = Eth + (th_ref-th)*dt;
    Epsi = Epsi + (Xref(4)-psi)*dt;
%     Utx = Kphi*[X(7);X(10)] + Gphi*Ephi + FFphi*phi_ref + FFinitphi*[X0(7);X0(10)];
%     Uty = Kphi*[X(8);X(11)] + Gphi*Eth + FFphi*th_ref + FFinitphi*[X0(8);X0(11)];
%     Utz = Kpsi*[X(9);X(12)] + Gpsi*Epsi + FFpsi*Xref(4) + FFinitpsi*[X0(9);X0(12)];
    Utx = Kphi*[X(7);X(10)] + Gphi*Ephi;
    Uty = Kphi*[X(8);X(11)] + Gphi*Eth;
    Utz = Kpsi*[X(9);X(12)] + Gpsi*Epsi;
    U = [Ualt; Utx; Uty; Utz];
    %}
    %} 
    
    %{%
    % NonlinearDynamics (Equation of Motion)
    dX1 = getNonlineardX_earth(X, U, Vw)*dt;
    dX2 = getNonlineardX_earth(X+dX1/2, U, Vw)*dt;
    dX3 = getNonlineardX_earth(X+dX2/2, U, Vw)*dt;
    dX4 = getNonlineardX_earth(X+dX3, U, Vw)*dt;  
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;
    %}
    
    %{
    % Dummy just to check if Ux, Uy are functioning properly
    dX1 = getdX(X, [Ux;Uy;Ualt_virt], Axyz, Bxyz)*dt;
    dX2 = getdX(X+dX1/2, [Ux;Uy;Ualt_virt], Axyz, Bxyz)*dt;
    dX3 = getdX(X+dX2/2, [Ux;Uy;Ualt_virt], Axyz, Bxyz)*dt;
    dX4 = getdX(X+dX3, [Ux;Uy;Ualt_virt], Axyz, Bxyz)*dt;  
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;
    %}
end
