function m3str = mat2str4(A, B, ll)
    % Convert matrices to strings while preserving shape
    strA = join(arrayfun(@(row) sprintf('%g ', A(row, :)), 1:size(A, 1), 'UniformOutput', false), newline);
    strB = join(arrayfun(@(row) sprintf('%g ', B(row, :)), 1:size(B, 1), 'UniformOutput', false), newline);
    strL = join(arrayfun(@(row) sprintf('%g ', ll(row, :)), 1:size(ll, 1), 'UniformOutput', false), newline);
    
    % Combine the strings
    m3str = sprintf('Matrix A:\n%s\n\nMatrix B:\n%s\n\nMatrix L:\n%s', string(strA), string(strB), string(strL));

end