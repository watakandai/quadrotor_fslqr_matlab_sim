% Xctr_data = zeros(size(Actr,1),length(T_data));
% Xctr = zeros(size(Actr,1),1);
Xq_data = zeros(size(Aq,1),length(T_data));
Xq = zeros(size(Aq,1),1);
Xr_data = zeros(size(Ar,1),length(T_data));
Xr = zeros(size(Ar,1),1);
Dist = [0.01 0.01 0.01 0 0 0 0 0 0 0 0 0]';

for t=1:(length(T))     % t=0 ~ t=t_end
% Save Data
    T_data(:,t)  = t*dt;                        % time  t
    X_data(:,t)  = X;                         % state x
    Xq_data(:,t) = Xq;
    Xr_data(:,t) = Xr;
    U_data(:,t) = U;                            % input u
%     Xctr_data(:,t) = Xctr;                  % state of controller
%     Umotor_data(:,t) = Umotor;
    
    % ------------------------ For Expanded LQR ---------------------------%
    dXr1 = getdX(Xr, U, Ar, Br)*dt;
    dXr2 = getdX(Xr+dXr1/2, U, Ar, Br)*dt;
    dXr3 = getdX(Xr+dXr2/2, U, Ar, Br)*dt;
    dXr4 = getdX(Xr+dXr3, U, Ar, Br)*dt;
    Xr = Xr+(dXr1+2*dXr2+2*dXr3+dXr4)/6;

    % ------------------------- For Plant ---------------------------%
    % NonlinearDynamics (Equation of Motion)
    % change U to Umotor. U is not considering first order lag
    dX1 = getNonlineardX_body(X, U)*dt;
    dX2 = getNonlineardX_body(X+dX1/2, U)*dt;
    dX3 = getNonlineardX_body(X+dX2/2, U)*dt;
    dX4 = getNonlineardX_body(X+dX3, U)*dt;  
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;
    if t>100 && t<500
        X = X+Dist;
    end
%     U = K_lqr*(Xref-X);
%     U = -K_lqr*X;

    % ------------------------ For Expanded LQR ---------------------------%
    dXq1 = getdX(Xq, X, Aq, Bq)*dt;
    dXq2 = getdX(Xq+dXq1/2, X, Aq, Bq)*dt;
    dXq3 = getdX(Xq+dXq2/2, X, Aq, Bq)*dt;
    dXq4 = getdX(Xq+dXq3, X, Aq, Bq)*dt;
    Xq = Xq+(dXq1+2*dXq2+2*dXq3+dXq4)/6;

    U = - K_lqr(:,1:length(A))*X - K_lqr(:,length(A)+1:length(A)+length(Aq))*Xq - K_lqr(:,length(A)+length(Aq)+1:length(A)+length(Aq)+length(Ar))*Xr;
    % ------------------------- For Hinfinity ---------------------------%
%     % Difference between Ref and States
%     E = Xref-X;
%     % Runge kutta for Controller
%     dXctr1 = getdX(Xctr, E, Actr,Bctr)*dt;
%     dXctr2 = getdX(Xctr+dXctr1/2, E, Actr,Bctr)*dt;
%     dXctr3 = getdX(Xctr+dXctr2/2, E, Actr,Bctr)*dt;
%     dXctr4 =getdX(Xctr+dXctr3, E, Actr,Bctr)*dt;  
%     Xctr = Xctr+(dXctr1+2*dXctr2+2*dXctr3+dXctr4)/6;
%     U = Cctr*Xctr + Dctr*E;
%     % Umotor = alpha*U + (1-alpha)*Umotor;
end
