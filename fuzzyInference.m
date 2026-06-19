function val = fuzzyInference(eNorm, ecNorm)
    centers = linspace(-1, 1, 7);
    levels = linspace(-1, 1, 7);
    muE = fuzzifyVariable(eNorm, centers);
    muEC = fuzzifyVariable(ecNorm, centers);
    ruleTable = [
        1 1 2 2 3 4 4;
        1 2 2 3 4 5 5;
        2 2 3 4 5 6 6;
        2 3 4 4 4 5 6;
        3 4 5 5 6 6 7;
        3 5 6 6 7 7 7;
        4 4 6 7 7 7 7
    ];
    numerator = 0;
    denominator = 0;
    for i = 1:7
        for j = 1:7
            w = min(muE(i), muEC(j));
            numerator = numerator + w * levels(ruleTable(i, j));
            denominator = denominator + w;
        end
    end
    if denominator < eps
        val = 0;
    else
        val = numerator / denominator;
    end
end
