function success = draw_3d_animation(T, X_data, Xlqr_data, l)
%%  3D
%{%
% vidObj = VideoWriter(sprintf('Motion_f=%i.avi', freq));
% open(vidObj)


figure
set(gcf, 'Name', '3D Position');
az = -60.5; el = 45;
legend('expd','lqr'); 
x_min=min([X_data(1,:) Xlqr_data(1,:)])-2*l;
x_max=max([X_data(1,:) Xlqr_data(1,:)])+2*l;
y_min=min([X_data(2,:) Xlqr_data(2,:)])-2*l;
y_max=max([X_data(2,:) Xlqr_data(2,:)])+2*l;
z_min=min([X_data(3,:) Xlqr_data(3,:)])-2*l;
z_max=max([X_data(3,:) Xlqr_data(3,:)])+2*l;
for t=1:length(T)-1
    x = X_data(1,t);
    y = X_data(2,t);
    z = X_data(3,t); 
    phi = X_data(7,t);
    th = X_data(8,t);
    psi = X_data(9,t);
    x_lqr = Xlqr_data(1,t);
    y_lqr = Xlqr_data(2,t);
    z_lqr = Xlqr_data(3,t);
    phi_lqr = Xlqr_data(7,t);
    th_lqr = Xlqr_data(8,t);
    psi_lqr = Xlqr_data(9,t);    
    plot3(X_data(1,1:t),X_data(2,1:t),X_data(3,1:t),':g', Xlqr_data(1,1:t), Xlqr_data(2,1:t), Xlqr_data(3,1:t),':m'); grid on; 
    xlim([x_min x_max]); ylim([y_min y_max]); zlim([z_min z_max]);
    line([x_lqr+l*cos(th_lqr)*cos(psi_lqr) x_lqr-l*cos(th_lqr)*cos(psi_lqr)], [y_lqr+l*(sin(phi_lqr)*sin(th_lqr)*cos(psi_lqr)-cos(phi_lqr)*sin(psi_lqr)) y_lqr-l*(sin(phi_lqr)*sin(th_lqr)*cos(psi_lqr)-cos(phi_lqr)*sin(psi_lqr))], [z_lqr+l*(cos(phi_lqr)*sin(th_lqr)*cos(psi_lqr)+sin(phi_lqr)*sin(psi_lqr)) z_lqr-l*(cos(phi_lqr)*sin(th_lqr)*cos(psi_lqr)+sin(phi_lqr)*sin(psi_lqr))]);
    line([x_lqr+l*cos(th_lqr)*sin(psi_lqr) x_lqr-l*cos(th_lqr)*sin(psi_lqr)], [y_lqr+l*(sin(phi_lqr)*sin(th_lqr)*sin(psi_lqr)+cos(phi_lqr)*cos(psi_lqr)) y_lqr-l*(sin(phi_lqr)*sin(th_lqr)*sin(psi_lqr)+cos(phi_lqr)*cos(psi_lqr))], [z_lqr+l*(cos(phi_lqr)*sin(th_lqr)*sin(psi_lqr)-sin(phi_lqr)*cos(psi_lqr)) z_lqr-l*(cos(phi_lqr)*sin(th_lqr)*sin(psi_lqr)-sin(phi_lqr)*cos(psi_lqr))]);
    line([x+l*cos(th)*cos(psi) x-l*cos(th)*cos(psi)], [y+l*(sin(phi)*sin(th)*cos(psi)-cos(phi)*sin(psi)) y-l*(sin(phi)*sin(th)*cos(psi)-cos(phi)*sin(psi))], [z+l*(cos(phi)*sin(th)*cos(psi)+sin(phi)*sin(psi)) z-l*(cos(phi)*sin(th)*cos(psi)+sin(phi)*sin(psi))]);
    line([x+l*cos(th)*sin(psi) x-l*cos(th)*sin(psi)], [y+l*(sin(phi)*sin(th)*sin(psi)+cos(phi)*cos(psi)) y-l*(sin(phi)*sin(th)*sin(psi)+cos(phi)*cos(psi))], [z+l*(cos(phi)*sin(th)*sin(psi)-sin(phi)*cos(psi)) z-l*(cos(phi)*sin(th)*sin(psi)-sin(phi)*cos(psi))]);
    view(az, el);
    xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
    title(sprintf('%0.1f/%i [s]',t*dt,t_end));
    drawnow;

%     currFrame = getframe(gcf);
%     writeVideo( vidObj, currFrame );
end

% close( vidObj );
%}
success = true;