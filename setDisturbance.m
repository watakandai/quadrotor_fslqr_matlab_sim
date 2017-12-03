function [Vw, Vx] = setDisturbance(flagWind, Vx, Au,Av,Aw,Bu,Bv,Bw, Cwind, t, dt, freq, Amp, wind_stop_time)

if wind_stop_time ~=0 && t*dt >= wind_stop_time
    Vw=[0 0 0]';
else
    % Sign Disturbance
    if flagWind==1
        if t < (1/freq/dt/2)
            vw = Amp * sin(2*pi*freq*t*dt);
            Vw=[vw vw vw]';
        else
            Vw=[0 0 0]';
        end
    elseif flagWind==111
        vw = Amp * sin(2*pi*freq*t*dt);
        Vw=[vw vw vw]';
    elseif flagWind==0
        Vw=[0 0 0]';
    elseif flagWind==3
        Wv = wgn(3,1,1);
        dVwind1 = getdVwind(Vx, Wv, Au,Av,Aw,Bu,Bv,Bw)*dt;
        dVwind2 = getdVwind(Vx+dVwind1/2, Wv, Au,Av,Aw,Bu,Bv,Bw)*dt;
        dVwind3 = getdVwind(Vx+dVwind2/2, Wv, Au,Av,Aw,Bu,Bv,Bw)*dt;
        dVwind4 = getdVwind(Vx+dVwind3, Wv, Au,Av,Aw,Bu,Bv,Bw)*dt;
        Vx = Vx + (dVwind1+2*dVwind2+2*dVwind3+dVwind4)/6;
        Vw = Amp*Cwind*Vx;
    end
end
