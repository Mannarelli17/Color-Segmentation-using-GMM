% model = scaling_factors, gaussian_means, covariances
function cluster = testGMM(pi_, mean_, cov_, tau, path)
 
    k = size(mean_, 2); % jig to find number of clusters... hahahaha
    num_of_images = length(path); % number of images
    cluster = ones(640, 480, 3, num_of_images); % allocating space
    
    for i = 1:num_of_images % for each image
        
        imagePath=fullfile(path(i).folder, path(i).name); % image path
        image = imread(imagePath); % image as nxm

        % we need to rotate the image if all the clusters are going to be
        % returned properly, I should probably fix them later but im not
        % because I do not feel like it and it doesnt affect anything
        if size(image, 1) == 480
            image = imrotate(image, 90);
        end
        n = size(image, 1);
        m = size(image, 2);
        image = transpose(reshape(image, n*m, 3)); % our list of rgb vectors :D
        for j = 1:n*m % for each pixel
            x = double(image(:, j));
            sum = 0;
            for g = 1:k % for each cluster
                scale = pi_(k);
                sigma = cov_(:,:,k);
                mu = mean_(:, k);
                sum = sum + scale*p(x,sigma,mu);
            end
            % if it does not pass threshold then it is not orange
            % and so we set the pixel to black
            if sum < tau
                image(:, j) = [0 ; 0 ; 0];
                   %display(image(:, j));
            else
                image(:, j) = [255 ; 255 ; 255];
            end

        end
        cluster(:, :, :, i) = reshape(transpose(image), n, m, 3);
    end
end

function posterior = p(x, sigma, mu)
    lh = exp(-0.5*transpose(x - mu)*(sigma\(x-mu)))/sqrt(det(sigma)*(2*pi)^3);
    prior = 0.5; % uniform distribution
    posterior = lh*prior;
end
