function pieOf(cat, values, ti)
%PIEOF Creates a pie plot from noncategorized data
    materials = unique(cat);
    totalMass = zeros(size(materials));
    massLabels = string(size(materials));
    
    for i = 1:length(materials)
        idx = strcmp(cat, materials{i});
        totalMass(i) = sum(values(idx));
        massLabels(i) = sprintf(' (%.0fg)', totalMass(i)*1000);
    end
    
    pieChart = piechart(totalMass, materials);
    title(ti);    
    
    % Add data labels

    pieChart.Labels = pieChart.Names + massLabels;
end

