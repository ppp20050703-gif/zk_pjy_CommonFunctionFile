function saveFuzzyRuleTable(outPath)
    labels = {'NB', 'NM', 'NS', 'ZO', 'PS', 'PM', 'PB'};
    ruleIndex = [
        1 1 2 2 3 4 4;
        1 2 2 3 4 5 5;
        2 2 3 4 5 6 6;
        2 3 4 4 4 5 6;
        3 4 5 5 6 6 7;
        3 5 6 6 7 7 7;
        4 4 6 7 7 7 7
    ];
    rules = cell(7, 7);
    for i = 1:7
        for j = 1:7
            rules{i, j} = labels{ruleIndex(i, j)};
        end
    end
    colNames = cell(1, 7);
    rowNames = cell(1, 7);
    for i = 1:7
        colNames{i} = ['ec_', labels{i}];
        rowNames{i} = ['e_', labels{i}];
    end
    T = cell2table(rules, 'VariableNames', colNames, 'RowNames', rowNames);
    writetable(T, outPath, 'WriteRowNames', true);
end
