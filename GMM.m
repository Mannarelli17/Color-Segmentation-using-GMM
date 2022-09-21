function [cluster, d] = GMM
    %set these to something else
    tau = 0;
    K = 0;
    %Need to figure out how to store the model
    
    %train
    path=dir('/Users/jeffreyzhang/Documents/MATLAB/CMSC426/jzhang45_proj1/train_images/*.jpg');
    orange_pixels = loadingData(path);
    [scaling_factor, gaussian_mean, covariance] = trainGMM(orange_pixels, K);
    
    %test
    path=dir('/Users/jeffreyzhang/Documents/MATLAB/CMSC426/jzhang45_proj1/test_images/*.jpg');
    orange_pixels = loadingData(path);
    cluster = testGMM(scaling_factor, gaussian_mean, covariance, orange_pixels, tau);
    d = measureDepth(cluster);
    plotGMM(scaling_factor, gaussian_mean, covariance);
end

function orange_pixels = loadingData(path)
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
end
