function dataPoints = labData();
    ideal = [1.22;2.45;3.67;4.90];
    errorRange = ideal .* .05;
    error = -errorRange + errorRange .* 2 .* rand(4, 1);
    dataPoints = ideal + error;
end
