function equivalence = isEquivalentMatrix(matrix1,matrix2)
%     equivalence = isequal(sort(matrix1),sort(matrix2));
    [~,matrix_1_sort_idx] = sort(matrix1(:,1));
    [~,matrix_2_sort_idx] = sort(matrix2(:,1));
    sorted_matrix_1 = matrix1(matrix_1_sort_idx,:);
    sorted_matrix_2 = matrix2(matrix_2_sort_idx,:);
    equivalence = isequal(sorted_matrix_1,sorted_matrix_2); 





end