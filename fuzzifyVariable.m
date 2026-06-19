function mu = fuzzifyVariable(x, centers)
    x = limitValue(x, -1, 1);
    n = numel(centers);
    mu = zeros(1, n);
    for i = 1:n
        if i == 1
            if x <= centers(1)
                mu(i) = 1;
            elseif x < centers(2)
                mu(i) = (centers(2) - x) / (centers(2) - centers(1));
            end
        elseif i == n
            if x >= centers(n)
                mu(i) = 1;
            elseif x > centers(n-1)
                mu(i) = (x - centers(n-1)) / (centers(n) - centers(n-1));
            end
        else
            left = centers(i-1);
            c = centers(i);
            right = centers(i+1);
            if x >= left && x <= c
                mu(i) = (x - left) / (c - left);
            elseif x > c && x <= right
                mu(i) = (right - x) / (right - c);
            end
        end
    end
end
