%read all the files in the directory
path=dir('./train_images/*.jpg');
%convert stack to store R,G,B channels of entire dataset
op = zeros(1,3);

for i=1:length(path)
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
    %mu = mean(orange_pixels);
end

% delete the forst row of pure zeros we used earlier
op(1, :) = [];

%Change threshold to something else
tau = 0;

% find mu
mu = transpose(mean(op));

% find covariance matrix
Sigma = cov(double(op));

display(Sigma)

% x is test pixel
x = [203 ; 200 ; 193];
prior = 0.5;

% find probability of color given pixel values
likelihood = exp(-0.5*transpose(x - mu)*(Sigma\(x-mu)))/sqrt(det(Sigma)*(2*pi)^3);

posterior = likelihood*prior;

display(posterior);

%Test images to show the orange ball clustered in each image
for images = 1:length(path)
    image_path = fullfile(path(images).folder, path(images).name);
    [filepath,name,ext] = fileparts(image_path);

    image = imread(image_path);
    img_lab = rgb2lab(image);
    BW = (img_lab(:,:,1)>=20)&(img_lab(:,:,1)<=90)&(img_lab(:,:,2)>=15)...
        &(img_lab(:,:,2)<=50)&(img_lab(:,:,3)>=10)&(img_lab(:,:,3)<=45);
    stats = regionprops('table',BW,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
    imshow(BW)
end


