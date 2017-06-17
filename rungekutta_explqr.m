X = X0;
U = U0;
% boxes to store data
T_data = T;                                    % time t
Xlqr_data = zeros(length(X), length(T_data));     % state x
Ulqr_data = zeros(length(U), length(T_data));     % input u to the motor
Elqr_data = zeros(length(E), length(T_data));

XE = zeros(length(X)+length(Xref), 1);
E = zeros(length(Xref),1);

for t=1:(length(T))     % t=0 ~ t=t_end
% Save Data
    T_data(:,t)  = t*dt;                        % time  t
    Xlqr_data(:,t)  = X;                         % state x
    Ulqr_data(:,t) = U;                            % input u
    Elqr_data(:,t) = E;

    % ----------------------- For Integral -------------------------%
    % x, y, z, psi
    dXE1 = getdXE(XE, A, B, Cref, U, Xref)*dt;
    dXE2 = getdXE(XE+dXE1/2, A, B, Cref, U, Xref)*dt;
    dXE3 = getdXE(XE+dXE2/2,  A, B, Cref, U, Xref)*dt;
    dXE4 = getdXE(XE+dXE3, A, B, Cref, U, Xref)*dt;  
    XE = XE+(dXE1+2*dXE2+2*dXE3+dXE4)/6;
    
    % ------------------------- For Plant ---------------------------%
    % Sign Disturbance 
    if t < (1/freq/dt/2)
        vw = Amp * sin(2*pi*freq*t*dt);
        Vw=[vw vw vw]';
    else
        Vw=[0 0 0]';
    end
    % NonlinearDynamics (Equation of Motion)
    dX1 = getNonlineardX_body(X, U, Vw)*dt;
    dX2 = getNonlineardX_body(X+dX1/2, U, Vw)*dt;
    dX3 = getNonlineardX_body(X+dX2/2, U, Vw)*dt;
    dX4 = getNonlineardX_body(X+dX3, U, Vw)*dt;  
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;

    XE(1:length(X)) = X;
    
    U = - K_explqr*XE;
end
