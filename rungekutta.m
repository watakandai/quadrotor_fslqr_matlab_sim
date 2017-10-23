X = X0;
U = U0;
% boxes to store data
T_data = T;                                    % time t
X_data = zeros(length(X), length(T_data));     % state x
U_data = zeros(length(U), length(T_data));     % input u to the motor
Xk = zeros(size(Ak,1),1);
Xk_data = zeros(length(Xk),length(T_data));
Vx = zeros(length(Au)+length(Av)+length(Aw), 1);
Vw = zeros(3,1);
Vw_data=zeros(length(Vw), length(T_data));

tic;
for t=1:(length(T))     % t=0 ~ t=t_end
% Save Data
    T_data(:,t)  = t*dt;                        % time  t
    X_data(:,t) = X;                           % state x
    Xk_data(:,t) = Xk;
    U_data(:,t) = U;                            % input u
    Vw_data(:,t) = Vw ;

    % ------------------------- For Plant ---------------------------%
    % Sign Disturbance 
    Vw = setDisturbance(flagSine, Vx, Au, Av, Aw, Bu, Bv, Bw, t, dt, freq, Amp);
    
    % NonlinearDynamics (Equation of Motion)
    dX1 = getNonlineardX_body(X, U, Vw)*dt;
    dX2 = getNonlineardX_body(X+dX1/2, U, Vw)*dt;
    dX3 = getNonlineardX_body(X+dX2/2, U, Vw)*dt;
    dX4 = getNonlineardX_body(X+dX3, U, Vw)*dt;  
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;
    
%     [A, B] = getSDREState(X, m, g, Ixx, Iyy, Izz);
%     [Ak, Bk, Ck, Dk]=getSDREController(A, B, C, D, Aq,Bq,Cq,Dq, Ar,Br,Cr,Dr);
    
    % ------------------------ For Expanded LQR ---------------------------%
    dXk1 = getdX(Xk, X, Ak, Bk)*dt;
    dXk2 = getdX(Xk+dXk1/2, X, Ak, Bk)*dt;
    dXk3 = getdX(Xk+dXk2/2, X, Ak, Bk)*dt;
    dXk4 = getdX(Xk+dXk3, X, Ak, Bk)*dt;
    Xk = Xk+(dXk1+2*dXk2+2*dXk3+dXk4)/6;
    U = Ck*Xk + Dk*X;
end
toc
