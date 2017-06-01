
for i=1:(length(T))     % t=0 ~ t=t_end
    % Save Data
    X_data(:,i)  = X;                       % state x
%     Xctr_data(:,i) = Xctr;                  % state of controller
    U_data(:,i)  = U;                       % input u
%     Umotor_data(:,i) = Umotor;
    T_data(:,i)  = i*dt;                    % time  t
    
    % ------------------------- For Plant ---------------------------%
    % NonlinearDynamics (Equation of Motion)
    % change U to Umotor. U is not considering first order lag
    dX1 = getNonlineardX_body(X, U)*dt;
    dX2 = getNonlineardX_body(X+dX1/2, U)*dt;
    dX3 = getNonlineardX_body(X+dX2/2, U)*dt;
    dX4 = getNonlineardX_body(X+dX3, U)*dt;  
    
    X = X+(dX1+2*dX2+2*dX3+dX4)/6;
    % ------------------------- For Hinfinity ---------------------------%
%     % Difference between Ref and States
%     E = Xref-X;
%     % Runge kutta for Controller
%     dXctr1 = getControllerdX(Xctr, E, Actr,Bctr)*dt;
%     dXctr2 = getControllerdX(Xctr+dXctr1/2, E, Actr,Bctr)*dt;
%     dXctr3 = getControllerdX(Xctr+dXctr2/2, E, Actr,Bctr)*dt;
%     dXctr4 =getControllerdX(Xctr+dXctr3, E, Actr,Bctr)*dt;  
%     Xctr = Xctr+(dXctr1+2*dXctr2+2*dXctr3+dXctr4)/6;
%     U = Cctr*Xctr + Dctr*E;
%     % Umotor = alpha*U + (1-alpha)*Umotor;
    % ---------------------------- For LQR ------------------------------%
%     Xref(1,1) = Xref_sin(:,i);
    U = K_lqr*(Xref-X)+ U0;
end
