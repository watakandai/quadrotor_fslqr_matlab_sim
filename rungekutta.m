X = X0;
U = U0;
% boxes to store data
T_data = T;                                    % time t
X_data = zeros(length(X), length(T_data));     % state x
U_data = zeros(length(U), length(T_data));     % input u to the motor
XE = zeros(length(X)+length(Xref), 1);
XE_data = zeros(length(XE), length(T_data));
E = zeros(length(Xref),1);
E_data = zeros(length(E), length(T_data));
Xk = zeros(size(Ak,1),1);
Xk_data = zeros(length(Xk),length(T_data));
Vwind = zeros(length(Au)+length(Av)+length(Aw), 1);
Vw = zeros(3,1);
Vw_data=zeros(length(Vw), length(T_data));

tic;
for t=1:(length(T))     % t=0 ~ t=t_end
% Save Data
    T_data(:,t)  = t*dt;                        % time  t
    X_data(:,t)  = X;                         % state x
    Xk_data(:,t) = Xk;
    U_data(:,t) = U;                            % input u
    E_data(:,t) = E;
    Vw_data(:,t) = Vw ;
%     Xctr_data(:,t) = Xctr;                  % state of controller
%     Umotor_data(:,t) = Umotor;

    % ----------------------- For Integral -------------------------%
    % x, y, z, psi
    % Need to create XE, XE_data, Axe, Bxe, Bref
    dXE1 = getdXE(XE, A, B, Cref, U, Xref)*dt;
    dXE2 = getdXE(XE+dXE1/2, A, B, Cref, U, Xref)*dt;
    dXE3 = getdXE(XE+dXE2/2,  A, B, Cref, U, Xref)*dt;
    dXE4 = getdXE(XE+dXE3, A, B, Cref, U, Xref)*dt;  
    XE = XE+(dXE1+2*dXE2+2*dXE3+dXE4)/6;
    E = XE(1+length(X):length(X)+length(E));

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

    % NonlinearDynamics (Equation of Motion)
    dX1 = getNonlineardX_body(X, U, Vw)*dt;
    dX2 = getNonlineardX_body(X+dX1/2, U, Vw)*dt;
    dX3 = getNonlineardX_body(X+dX2/2, U, Vw)*dt;
    dX4 = getNonlineardX_body(X+dX3, U, Vw)*dt;  
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;
    
    [A, B] = getSDREState(X);
    [Ak, Bk, Ck, Dk]=getSDREController(A, B, C, D, Aq,Bq,Cq,Dq, Ar,Br,Cr,Dr);
    
    % ------------------------ For Expanded LQR ---------------------------%
    XE(1:length(X)) = X;
    dXk1 = getdX(Xk, XE, Ak, Bk)*dt;
    dXk2 = getdX(Xk+dXk1/2, XE, Ak, Bk)*dt;
    dXk3 = getdX(Xk+dXk2/2, XE, Ak, Bk)*dt;
    dXk4 = getdX(Xk+dXk3, XE, Ak, Bk)*dt;
    Xk = Xk+(dXk1+2*dXk2+2*dXk3+dXk4)/6;
    U = Ck*Xk + Dk*XE;
end
toc
