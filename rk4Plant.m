function xNext = rk4Plant(x, u, dt, plant)
    f = @(xx, uu) [xx(2); -plant.den(3) * xx(1) - plant.den(2) * xx(2) + plant.num * uu];
    k1 = f(x, u);
    k2 = f(x + 0.5 * dt * k1, u);
    k3 = f(x + 0.5 * dt * k2, u);
    k4 = f(x + dt * k3, u);
    xNext = x + dt * (k1 + 2*k2 + 2*k3 + k4) / 6;
end
