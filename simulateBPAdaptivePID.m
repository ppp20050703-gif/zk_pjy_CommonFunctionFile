function out = simulateBPAdaptivePID(t, dt, plant, cfg)
    n = numel(t);
    x = [0; 0];
    y = zeros(n, 1);
    u = zeros(n, 1);
    e = zeros(n, 1);
    de = zeros(n, 1);
    K = zeros(n, 3);
    intE = 0;
    ePrev = 0;
    deFilt = 0;
    H = cfg.hidden;
    W1 = 0.08 * randn(H, 3);
    b1 = zeros(H, 1);
    W2 = zeros(3, H);
    initRatio = (cfg.Kinit - cfg.Kmin) ./ (cfg.Kmax - cfg.Kmin);
    initRatio = min(max(initRatio, 0.02), 0.98);
    b2 = log(initRatio(:) ./ (1 - initRatio(:)));
    dW1Prev = zeros(size(W1)); db1Prev = zeros(size(b1));
    dW2Prev = zeros(size(W2)); db2Prev = zeros(size(b2));
    for k = 1:n
        y(k) = x(1);
        e(k) = 1 - y(k);
        intE = limitValue(intE + e(k) * dt, -cfg.integralLimit, cfg.integralLimit);
        if k == 1
            deRaw = 0;
        else
            deRaw = (e(k) - ePrev) / dt;
        end
        deFilt = cfg.derivativeAlpha * deFilt + (1 - cfg.derivativeAlpha) * deRaw;
        de(k) = deFilt;

        z = [limitValue(e(k), -1, 1); limitValue(intE / cfg.integralLimit, -1, 1); limitValue(deFilt / 5, -1, 1)];
        h = tanh(W1 * z + b1);
        net = W2 * h + b2;
        sig = 1 ./ (1 + exp(-net));
        gains = cfg.Kmin(:) + (cfg.Kmax(:) - cfg.Kmin(:)) .* sig;
        K(k, :) = gains(:)';

        pidFeatures = [e(k); intE; deFilt];
        u(k) = gains(1) * e(k) + gains(2) * intE + gains(3) * deFilt;
        u(k) = limitValue(u(k), cfg.uMin, cfg.uMax);

        deltaOut = e(k) * pidFeatures .* (cfg.Kmax(:) - cfg.Kmin(:)) .* sig .* (1 - sig);
        deltaOut = limitVector(deltaOut, -2.0, 2.0);
        gradW2 = deltaOut * h';
        gradb2 = deltaOut;
        deltaHidden = (W2' * deltaOut) .* (1 - h.^2);
        gradW1 = deltaHidden * z';
        gradb1 = deltaHidden;

        dW2 = cfg.eta * gradW2 + cfg.momentum * dW2Prev;
        db2 = cfg.eta * gradb2 + cfg.momentum * db2Prev;
        dW1 = cfg.eta * gradW1 + cfg.momentum * dW1Prev;
        db1 = cfg.eta * gradb1 + cfg.momentum * db1Prev;
        W2 = W2 + dW2; b2 = b2 + db2;
        W1 = W1 + dW1; b1 = b1 + db1;
        dW2Prev = dW2; db2Prev = db2; dW1Prev = dW1; db1Prev = db1;

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
    out.K = K;
end
