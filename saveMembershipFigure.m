function saveMembershipFigure(outPath)
    x = linspace(-1, 1, 800);
    centers = linspace(-1, 1, 7);
    labels = {'NB', 'NM', 'NS', 'ZO', 'PS', 'PM', 'PB'};
    y = zeros(numel(x), 7);
    for k = 1:numel(x)
        y(k, :) = fuzzifyVariable(x(k), centers);
    end
    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 620]);
    plot(x, y, 'LineWidth', 1.5);
    grid on;
    xlabel('Normalized variable');
    ylabel('Membership degree');
    title('Fuzzy membership functions');
    legend(labels, 'Location', 'bestoutside');
    set(gca, 'FontName', 'Arial', 'FontSize', 11);
    saveas(fig, outPath);
    close(fig);
end
