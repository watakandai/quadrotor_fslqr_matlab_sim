X = X0;
U = U0;
% boxes to store data
T_data = T;                                    % time t
Xlqr_data = zeros(length(X), length(T_data));     % state x
Ulqr_data = zeros(length(U), length(T_data));     % input u to the motor

Vwind = zeros(length(Au)+length(Av)+length(Aw), 1);
Vw = zeros(3,1);
Vwlqr_data=zeros(length(Vw), length(T_data));

for t=1:(length(T))     % t=0 ~ t=t_end
% Save Data
    T_data(:,t)  = t*dt;                        % time  t
    Xlqr_data(:,t)  = X;                         % state x
    Ulqr_data(:,t) = U;                            % input u
    Vwlqr_data(:,t) = Vw ;

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
   
    U = - K_lqr*X;
end
