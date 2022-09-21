function [scaling_factors, gaussian_means, covariances] = trainGMM(orange_pixels, k)
    %set epsilon to something else
    epsilon = 0;
    % initialize pi_i to be 1/k
    scaling_factors = ones(k,1)/k;
    %get the means and covariances of the clusters
    [gausian_means, covariances] = clusterParameters(orange_pixels, k);
    
end
 
% gets the means and covariances of the clusters
% splits the data into k clusters
% returns the means (kx1x3) and covariances (kx3x3) of the clusters
function [gausian_means, covariances] = clusterParameters(orange_pixels, k)
    % declaration and initialization of variables to 0
    gausian_means = zeros(1,3);
    covariances = zeros(3,3);
    for i = 2:k
        gausian_means(:,:,i) = zeros(1,3);
        covariances(:,:,i) = zeros(3,3);
    end
    split_amount = size(orange_pixels);
    total = split_amount(1);
    gathered = 0;
    split_amount = floor(total/k);
    for i = 1:k
        temp_total = zeros(1,3);
        for j = 1:split_amount
            temp_total(1) = temp_total(1) + orange_pixels(gathered + 1,1);
            temp_total(2) = temp_total(2) + orange_pixels(gathered + 1,2);
            temp_total(3) = temp_total(3) + orange_pixels(gathered + 1,3);
            gathered = gathered + 1;
        end
        extra = 0;
        %in case we have remainders
        while(i == k && gathered < total)
            temp_total(1) = temp_total(1) + orange_pixels(gathered + 1,1);
            temp_total(2) = temp_total(2) + orange_pixels(gathered + 1,2);
            temp_total(3) = temp_total(3) + orange_pixels(gathered + 1,3);
            extra  = extra + 1;
            gathered = gathered + 1;
        end
        temp_average = temp_total/(split_amount + extra);
        gausian_means(:,:,i) = temp_average;
        
    end
    
end
