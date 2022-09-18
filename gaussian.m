%read all the files in the directory
path=dir('/Users/jeffreyzhang/Documents/MATLAB/CMSC426/jzhang45_proj1/train_images/*.jpg');
%convert stack to store R,G,B channels of entire dataset
%imageStack=zeros(1,3);
orange_pixels = zeros(1,3);
%imageStack_lab=zeros(1,3);
for i=1:length(path)
    imagePath=fullfile(path(1).folder, path(1).name);
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
    %mu = mean(orange_pixels);
end

%Change threshold to something else
tau = 0;

mu = mean(orange_pixels);
Sigma = cov(orange_pixels);
%Sigma_inv = inv(Sigma);
cov_det = det(Sigma);
orange_pixels_trans = transpose(orange_pixels);

p_x = 0.5;
p_x_orange = exp(-0.5*orange_pixels_trans*Sigma\orange_pixels)/sqrt(cov_det*(2*pi)^3);

p_orange_x = p_x*p_x_orange;



