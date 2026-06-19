function saveSeries(path, t, names, values)
    T = array2table([t, values], 'VariableNames', [{'time_s'}, names]);
    writetable(T, path);
end
