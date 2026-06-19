function m = stepMetrics(t, y, r)
    target = r(end);
    e = target - y;
    m.finalValue = y(end);
    m.steadyStateError = abs(target - y(end));
    m.overshootPercent = max(0, (max(y) - target) / max(abs(target), eps) * 100);
    idx10 = find(y >= 0.1 * target, 1, 'first');
    idx90 = find(y >= 0.9 * target, 1, 'first');
    if isempty(idx10) || isempty(idx90)
        m.riseTime = NaN;
    else
        m.riseTime = t(idx90) - t(idx10);
    end
    band = 0.02 * max(abs(target), eps);
    outside = find(abs(y - target) > band);
    if isempty(outside)
        m.settlingTime2Percent = 0;
    elseif outside(end) == numel(t)
        m.settlingTime2Percent = NaN;
    else
        m.settlingTime2Percent = t(outside(end) + 1);
    end
    m.IAE = trapz(t, abs(e));
    m.ITAE = trapz(t, t .* abs(e));
end
