function saveFigure(t, yMatrix, labels, titleText, xText, yText, outPath)
    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 620]);
    plot(t, yMatrix, 'LineWidth', 1.6);
    grid on;
    xlabel(xText);
    ylabel(yText);
    title(titleText);
    legend(labels, 'Location', 'best');
    set(gca, 'FontName', 'Arial', 'FontSize', 11);
    saveas(fig, outPath);
    close(fig);
end
