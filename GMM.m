function [cluster, d] = GMM
    % let tau be our threshold
    tau = 0;
    % let K be the number of clusters
    K = 5;
    
    % training step
    % gather all orange pixels in a list of RGB vectors
    orange_pixels = loadingDataTrain(dir('./train_images/*.jpg'));
    % gather coefficients for our GMM
    [scaling_factors, gaussian_means, covariances] = trainGMM(orange_pixels, K);
    
    % testing step
    %test (might have to change this to include non orange samples)
    path=dir('./test_images/*.jpg');
    pixels = loadingDataTest(path);
    cluster = testGMM(scaling, factors, gaussian_means, covariances, pixels, tau);
    d = measureDepth(cluster);
    plotGMM(scaling_factors, gaussian_means, covariances);
end

%%%%%%%%%%%%%%%%%%

% returns all of the orange pixels in the form of
% a list of RGB vectors
function orange_pixels = loadingDataTrain(path)
    orange_pixels = zeros(1,3);
    % change back to length(path)
    for i=1:1
        imagePath=fullfile(path(i).folder, path(i).name);
        %read the image
        image = imread(imagePath);
        BW_image = roipoly(image);
        image(repmat(~BW_image,[1 1 3])) = 0;
        image=reshape(image,640*480,3);
        for pixel = 1:(640*480)
            if BW_image(pixel) == 1
                orange_pixels = vertcat(orange_pixels,image(pixel,:));
            end
        end 
    end
    orange_pixels(1, :) = [];
end

%%%%%%%%%%%%%%%%%%%

function pixels = loadingDataTest(path)
    pixels = zeros(1,3);
    %maybe test for 1 image at a time
    for i=1:length(path)
        imagePath=fullfile(path(i).folder, path(i).name);
        %read the image
        image = imread(imagePath);
        BW_image = roipoly(image);
        image(repmat(~BW_image,[1 1 3])) = 0;
        image=reshape(image,640*480,3);
        pixels = [pixels;image]
    end
    pixels(1, :) = [];
end
