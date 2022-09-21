
%read all the files in the directory
path=dir('./train_images/*.jpg');
%convert stack to store R,G,B channels of entire dataset
op = zeros(1,3);

for i=1:1
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

mu = mean(op);

r = double(op(:, 1));
g = double(op(:, 2));
b = double(op(:, 3));

rr = cov(r,r);
gg = cov(g,g);
bb = cov(b,b);
rg = cov(r,g);
rb = cov(r,b);
gb = cov(g,b);

Sigma = transpose([rr rg rb 
                   rg gg gb 
                   rb gb bb]);
display(Sigma)
% Sigma = cov(orange_pixels);
% %Sigma_inv = inv(Sigma);
% orange_pixels_trans = transpose(orange_pixels);
% 
% p_x = 0.5;
% p_x_orange = exp(-0.5*orange_pixels_trans*Sigma\orange_pixels)/sqrt(det(Sigma)*(2*pi)^3);
% 
% p_orange_x = p_x*p_x_orange;



