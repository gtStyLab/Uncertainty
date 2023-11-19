function [distance_matrix] = calcDistance(matrix1,matrix2)
    %This function serves to calculate the sum and minimum of Euclidean distance
    %between each column vector in matrix1 to each column vector in matrix2
    distance_matrix = nan(size(matrix1,2),size(matrix2,2));
    for col = 1:1:size(matrix1,2)
        vec = matrix1(:,col);
        solnLength = size(matrix2,2);
        aug_vec = repmat(vec,[1,solnLength]);
        distance_vec = sqrt(sum((aug_vec - matrix2).^2,1));
        distance_matrix(col,:) = distance_vec;
        
    end
    %The i-th row and j-th column in distance matrix represents the distance from
    %the i-th column in matrix 1 to the j-th column in matrix 2


end