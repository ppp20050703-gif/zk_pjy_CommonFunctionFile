function out = simulatePID(t, dt, plant, cfg)
    n = numel(t);
    x = [0; 0];
    y = zeros(n, 1);
    u = zeros(n, 1);
    e = zeros(n, 1);
    de = zeros(n, 1);
    intE = 0;
    ePrev = 0;
    deFilt = 0;
    if isfield(cfg, 'integralLimit')
        integralLimit = cfg.integralLimit;
    else
        integralLimit = 2.5;
    end
    for k = 1:n
        y(k) = x(1);
        e(k) = 1 - y(k);
        intE = limitValue(intE + e(k) * dt, -integralLimit, integralLimit);
        if k == 1
            deRaw = 0;
        else
            deRaw = (e(k) - ePrev) / dt;
        end
        deFilt = cfg.derivativeAlpha * deFilt + (1 - cfg.derivativeAlpha) * deRaw;
        de(k) = deFilt;
        u(k) = cfg.Kp * e(k) + cfg.Ki * intE + cfg.Kd * deFilt;
        u(k) = limitValue(u(k), cfg.uMin, cfg.uMax);
        if k < n
            x = rk4Plant(x, u(k), dt, plant);
        end
        ePrev = e(k);
    end
    out.t = t;
    out.y = y;
    out.u = u;
    out.e = e;
    out.de = de;
    out.gains = [cfg.Kp cfg.Ki cfg.Kd];
end
