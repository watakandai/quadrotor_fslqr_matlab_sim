% Xctr_data = zeros(size(Actr,1),length(T_data));
% Xctr = zeros(size(Actr,1),1);
Xk_data = zeros(size(Ak,1),length(T_data));
Xk = zeros(size(Ak,1),1);
Dist = [0.01 0.01 0.01 0 0 0 0 0 0 0 0 0]';
Amp = 0.01;
freq = 0.5;
for t=1:(length(T))     % t=0 ~ t=t_end
% Save Data
    T_data(:,t)  = t*dt;                        % time  t
    X_data(:,t)  = X;                         % state x
    Xk_data(:,t) = Xk;
    U_data(:,t) = U;                            % input u
%     Xctr_data(:,t) = Xctr;                  % state of controller
%     Umotor_data(:,t) = Umotor;

    % ------------------------- For Plant ---------------------------%
    % NonlinearDynamics (Equation of Motion)
    % change U to Umotor. U is not considering first order lag
    dX1 = getNonlineardX_body(X, U)*dt;
    dX2 = getNonlineardX_body(X+dX1/2, U)*dt;
    dX3 = getNonlineardX_body(X+dX2/2, U)*dt;
    dX4 = getNonlineardX_body(X+dX3, U)*dt;  
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;
%     U = K_lqr*(Xref-X);
%     U = -K_lqr*X;

    % Sign Disturbance 
    x = Amp * sin(2*pi*freq*t*dt);
    Dist=[0 0 0 x x x 0 0 0 0 0 0 ]';
    X = X+Dist;
    % ------------------------ For Expanded LQR ---------------------------%
    dXk1 = getdX(Xk, X, Ak, Bk)*dt;
    dXk2 = getdX(Xk+dXk1/2, X, Ak, Bk)*dt;
    dXk3 = getdX(Xk+dXk2/2, X, Ak, Bk)*dt;
    dXk4 = getdX(Xk+dXk3, X, Ak, Bk)*dt;
    Xk = Xk+(dXk1+2*dXk2+2*dXk3+dXk4)/6;
    U = Ck*Xk + Dk*X;
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
