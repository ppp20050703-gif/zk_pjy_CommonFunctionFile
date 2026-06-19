function out = simulateOpenLoop(t, dt, plant)
    n = numel(t);
    x = [0; 0];
    y = zeros(n, 1);
    u = ones(n, 1);
    for k = 1:n
        y(k) = x(1);
        if k < n
            x = rk4Plant(x, u(k), dt, plant);
        end
    end
    out.t = t;
    out.y = y;
    out.u = u;
end
