function [cluster, d] = GMM
    %set these to something else
    tau = 0;
    K = 0;
    %Need to figure out how to store the model
    
    %train
    path=dir('/Users/jeffreyzhang/Documents/MATLAB/CMSC426/jzhang45_proj1/train_images/*.jpg');
    orange_pixels = loadingDataTrain(path);
    [scaling_factors, gaussian_means, covariances] = trainGMM(orange_pixels, K);
    
    %test (might have to change this to include non orange samples)
    path=dir('/Users/jeffreyzhang/Documents/MATLAB/CMSC426/jzhang45_proj1/test_images/*.jpg');
    
    pixels = loadingDataTest(path);
    cluster = testGMM(scaling_factors, gaussian_means, covariances, pixels, tau);
    d = measureDepth(cluster);
    plotGMM(scaling_factors, gaussian_means, covariances);
end

function orange_pixels = loadingDataTraun(path)
    orange_pixels = zeros(1,3);
    for i=1:length(path)
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
