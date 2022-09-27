%read all the files in the directory
path=dir('./train_images/*.jpg');
%convert stack to store R,G,B channels of entire dataset
op = zeros(1,3);

for i=1:size(path)
    %read the image
    image = imread(fullfile(path(i).folder, path(i).name));

    %thresholding with roipoly
    BW_image = roipoly(image);
    image(repmat(~BW_image,[1 1 3])) = 0;
    image=reshape(image,640*480,3);

    % masking, collecting the vectors 
    for pixel = 1:(640*480)
         if BW_image(pixel) == 1
             op = vertcat(op,image(pixel,:));
         end
    end 
end

% delete the forst row of pure zeros we used earlier
op(1, :) = [];

% find mu
mu = transpose(mean(op));

% find covariance matrix
sigma = cov(double(op));

tau = .0000001;

% testing portion of single gaussian

path=dir('./test_images/*.jpg');

for i = 1:length(path) % iterate through every image

    imagePath=fullfile(path(i).folder, path(i).name);
    %read the image
    image = imread(imagePath);
    n = size(image,1);
    m = size(image,2);
    image=transpose(reshape(image,n*m,3));

    for j = 1:(n*m) % iterate through every pixel
        x = double(image(:,j)); % this is the current pixel of the current test image
        prob = p(x, sigma, mu);
        if prob < tau
            image(:,j) = [255;255;255];
        end
    end
    image = reshape(transpose(image),n,m,3);
    imshow(image);
end


function posterior = p(x, sigma, mu)
    lh = exp(-0.5*transpose(x - mu)*(sigma\(x-mu)))/sqrt(det(sigma)*(2*pi)^3);
    prior = 0.5; % uniform distribution
    posterior = lh*prior;
end




