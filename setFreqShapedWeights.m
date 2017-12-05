function [Aq,Bq,Cq,Dq, Ar,Br,Cr,Dr] = setFreqShapedWeights(W, DEBUG, setPosition)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Frequency Weight                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dynamic=false;
if dynamic==true
    setLagBef=true;
end

%-- State Weight --%
gain=1;
f=0.5; ze=1; w=2*pi*f; numBand=[0 2*ze*w 0]; denBand=[1 2*ze*w w^2];
f1=0.01; f2=10;  w1=2*pi*f1; w2=2*pi*f2; numLag=[1 w2]; denLag=[1 w1]; 
f=0.5; ze=5; w=2*pi*f; numBef=[1 2*ze*w w^2]; denBef=[1 0 w^2];
f=0.01; w=2*pi*f; numHigh=[1 0]; denHigh=[1 w];
f=1; w=2*pi*f; numLow=[0 w]; denLow=[1 w];
    setBandBef=false;
    setBef=false;
    setBand=false;
    setLowBef=false;
    setLow=false;
    setLag=true;
    setInvHighBef=false;
    setLagBef=false;
    if setBandBef == true
        num=conv(numBand,numBef); den=conv(denBand,denBef);
    elseif setBef==true
        num=numBef; den=denBef;
    elseif setBand==true
        num=numBand; den=denBand;
    elseif setLowBef==true
        num=conv(numLow,numBef); den=conv(denLow,denBef);
    elseif setLow==true
        num=numLow; den=denLow;
    elseif setLag==true
        num=numLag; den=denLag;
    elseif setLagBef==true
        num=conv(numLag,numBef); den=conv(denLag, denBef);
    elseif setInvHighBef==true
        num=conv(denHigh,numBef); den=conv(numHigh,denBef);
    end
    qx = nd2sys(1, 1, 1);
    qv = nd2sys(1, 1, 1);
    
    if setPosition == true
        xqx=daug(qx,qx,qx);
        xqv=daug(1,1,1);
    else
        if dynamic==true
            qx = nd2sys(num, den, 1);
            qv = nd2sys(1, 1, 1);
            xqx=daug(qv,qv,1);
            xqv=daug(qx,qx,qx);
        else
            qx = nd2sys(numBef, denBef, 1);
            qv = nd2sys(num, den, 1);
            xqx=daug(qx,qx,qx);
            xqv=daug(qv,qv,qv); 
        end
    end    
    xq1=daug(1,1,1);
    
    Xq=daug(xqx, xqv, xq1, xq1);
    [Aq,Bq,Cq,Dq]=unpck(Xq);
    

%-- Input Weight --%
gain=1; f=10; w=2*pi*f; num=w; den=[1 w];
    r = nd2sys(num, den, gain); 
    Xr=daug(1,1,1,r);
    [Ar,Br,Cr,Dr]=unpck(Xr);
    
    
% Figure
if DEBUG==true
    qx_g = frsp(qx, W);
    qv_g = frsp(qv, W);
    r_g = frsp(r, W); r_g=minv(r_g);
    qx_g_unpck = vunpck(vnorm(qx_g));
    qv_g_unpck = vunpck(vnorm(qv_g));
    r_g_unpck = vunpck(vnorm(r_g));
    figure
    loglog(W/(2*pi), qx_g_unpck, W/(2*pi), r_g_unpck, W/(2*pi), qv_g_unpck); grid on;
    xlim([min(W/(2*pi)) max(W/(2*pi))]);
    title('Frequency Weight'); xlabel('Frequency, Hz'); ylabel('Gain, dB'); legend('{\itW_x_y_z}', '{\itW_U}', '{\itW_u_v_w}');
end
