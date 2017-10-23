X = X0;
U = U0;
Z = 0;
% boxes to store data
T_data = T;                                    % time t
Xlqr_data = zeros(length(X), length(T_data));     % state x
Ulqr_data = zeros(length(U), length(T_data));     % input u to the motor
PhiRefLqr_data = zeros(1, length(T_data));
ThRefLqr_data = zeros(1, length(T_data));
phi_ref=0;
th_ref=0;
Ex=0; Ey=0; Ez=0; 
Ephi_data=zeros(1, length(T_data));
Eth_data=zeros(1, length(T_data));
Epsi_data=zeros(1, length(T_data));
Ephi=0; Eth=0; Epsi=0; Ee=0;
Xz=[0; 0; 0]; 
Ualt_virt=0;

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
    % ------------------------- For Plant ---------------------------%
    Vw = setDisturbance(flagSine, Vx, Au, Av, Aw, Bu, Bv, Bw, t, dt, freq, Amp);

    % get Values from the Raw Sensor
    % Left Blank
    %
    %
    phi=X(7);
    th=X(8);
    psi=X(9);
    
    % Process the data with the Oberserver
    % Left Blank
    %+
    
    %
    Ee = Ee + (Xref-Ce*X)*dt;
    U = Ke*X + Ge*Ee + FFe*Xref + FFinie*X0;
    Xerr = [X(1)-Xref(1);
            X(2)-Xref(2);
            X(3)-Xref(3);
            X(4); X(5); X(6); X(7); X(8); 
            X(9)-Xref(4); 
            X(10); X(11); X(12)];
%     U = -K_lqr*Xerr + [m*g; 0; 0; 0];
    
    %{
    % Altitude Controller
    % Determine The Altitude Input
%     dXz1 = getdX(Xz, [Ualt_virt; Xref(3)], Aerror, Bz)*dt;
%     dXz2 = getdX(Xz+dXz1/2, [Ualt_virt; Xref(3)], Aerror, Bz)*dt;
%     dXz3 = getdX(Xz+dXz2/2, [Ualt_virt; Xref(3)], Aerror, Bz)*dt;
%     dXz4 = getdX(Xz+dXz3, [Ualt_virt; Xref(3)], Aerror, Bz)*dt;  
%     Xz = Xz+(dXz1+2*dXz2+2*dXz3+dXz4)/6;
%     Ualt_virt = -Kz*Xz;                %=> Error State Need to be Integrated
%     Ualt = m*(Ualt_virt+g)/(cos(phi)*cos(psi));
    Ez = Ez + (Xref(3)-X(3))*dt;
    Ualt_virt = Kz*[X(3);X(6)] + Gz*Ez + FFz*Xref(3) + FFinitz*[X0(3);X0(6)];
    Ualt = m*(Ualt_virt+g);
    
    % Position Controller
        % Determine the Position Input -> Phi_ref & Theta_ref
%     Bxy = [0; Ualt/m; 0];
%     Kx = lqr(Aerror, Bxy, diag([1, 100, 1]), 1);
    Ex = Ex + (Xref(1)-X(1))*dt;
    Ux = Kxy*[X(1);X(4)] + Gxy*Ex + FFxy*Xref(1) + FFinitxy*[X0(1);X0(4)];
    Ey = Ey + (Xref(2)-X(2))*dt; 
    Uy = Kxy*[X(2);X(5)] + Gxy*Ey + FFxy*Xref(2) + FFinitxy*[X0(2);X0(5)];

    % Calc Phi_ref, Theta_ref
    phi_ref = -Uy/10;
    th_ref = Ux/10;
    phi_deg = phi_ref*180/pi
    th_deg = th_ref*180/pi;
%     phi_ref = asin((cos(phi)*sin(th)*sin(psi)-Uy)/cos(psi));
%     th_ref = asin((Ux-sin(phi)*sin(psi))/(cos(phi)*cos(psi)));
    
%     if phi_ref > 0.523599
%         phi_ref = 0.523599;
%     elseif phi_ref < -0.523599
%         phi_ref = -0.523599;
%     end
%     if th_ref > 0.523599
%         th_ref = 0.523599;
%     elseif th_ref < -0.523599
%         th_ref = -0.523599;
%     end
    
    % Atitude Controller
    Ephi = Ephi + (phi_ref-phi)*dt;
    Eth = Eth + (th_ref-th)*dt;
    Epsi = Epsi + (Xref(4)-psi)*dt;
    Utx = Kphi*[X(7);X(10)] + Gphi*Ephi + FFphi*phi_ref + FFinitphi*[X0(7);X0(10)]- Gphi*Ephi_data(:,t);
    Uty = Kphi*[X(8);X(11)] + Gphi*Eth + FFphi*th_ref + FFinitphi*[X0(8);X0(11)] - Gphi*Ephi_data(:,t);
    Utz = Kpsi*[X(9);X(12)] + Gpsi*Epsi + FFpsi*Xref(4) + FFinitpsi*[X0(9);X0(12)] - Gpsi*Ephi_data(:,t);  
%     Utx = Kphi*[X(7);X(10)] + Gphi*Ephi + FFphi*phi_ref + FFinitphi*[X0(7);X0(10)];
%     Uty = Kphi*[X(8);X(11)] + Gphi*Eth + FFphi*th_ref + FFinitphi*[X0(8);X0(11)];
%     Utz = Kpsi*[X(9);X(12)] + Gpsi*Epsi + FFpsi*Xref(4) + FFinitpsi*[X0(9);X0(12)];
    U = [Ualt; Utx/100; Uty/100; Utz/100];
    %} 
    
    % NonlinearDynamics (Equation of Motion)
    dX1 = getNonlineardX_earth(X, U, Vw)*dt;
    dX2 = getNonlineardX_earth(X+dX1/2, U, Vw)*dt;
    dX3 = getNonlineardX_earth(X+dX2/2, U, Vw)*dt;
    dX4 = getNonlineardX_earth(X+dX3, U, Vw)*dt;  
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;
end
