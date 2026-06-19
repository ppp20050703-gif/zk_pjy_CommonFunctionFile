function out = simulateFuzzyPid(t, dt, plant, cfg)
    n = numel(t);
    x = [0; 0];
    y = zeros(n, 1);
    u = zeros(n, 1);
    e = zeros(n, 1);
    ec = zeros(n, 1);
    intE = 0;
    ePrev = 0;
    ecFilt = 0;
    for k = 1:n
        y(k) = x(1);
        e(k) = 1 - y(k);
        intE = limitValue(intE + e(k) * dt, -cfg.integralLimit, cfg.integralLimit);
        if k == 1
            ecRaw = 0;
        else
            ecRaw = (e(k) - ePrev) / dt;
        end
        ecFilt = cfg.derivativeAlpha * ecFilt + (1 - cfg.derivativeAlpha) * ecRaw;
        ec(k) = ecFilt;
        en = limitValue(cfg.Ke * e(k), -1, 1);
        ecn = limitValue(cfg.Kec * ecFilt, -1, 1);
        fuzzyCompensation = fuzzyInference(en, ecn);
        u(k) = cfg.Kp * e(k) + cfg.Ki * intE + cfg.Kd * ecFilt + cfg.Kf * fuzzyCompensation;
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
    out.ec = ec;
end
