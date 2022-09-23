path=dir('./train_images/*.jpg');
imageStack=zeros(1,3);
op_lab = zeros(1,3);
imageStack_lab=zeros(1,3);
for image=1:length(path)-1
    image_path=fullfile(path(image).folder, path(image).name);

    image=imread(image_path);

    image_lab = rgb2lab(image);

    sliderBW = (image_lab(:,:,1)>=20)&(image_lab(:,:,1)<=90)&(image_lab(:,:,2)>=15)&(image_lab(:,:,2)<=50)&(image_lab(:,:,3)>=10)&(image_lab(:,:,3)<=45);
    BW_lab = sliderBW;

    % Initialize output masked image based on input image.
    maskedRGBImage_lab = image_lab;
    % Set background pixels where BW is false to zero.
    maskedRGBImage_lab(repmat(~BW_lab,[1 1 3])) = 0;
    maskedRGBImage_lab=reshape(maskedRGBImage_lab,640*480,3);
    %gathering all orange pixels(lab) in an matrix
    for pixels = 1:(640*480)
        if BW_lab(pixels) == 1
            op_lab = vertcat(op_lab,maskedRGBImage_lab(pixels,:));
        end
    end
end


prior = 0.5;
cov_orange = cov(op_lab);
mean_orange = mean(op_lab);
threshold = 0.0000003;

distance = zeros(1);
area_ball = zeros(1);
for images = 1:length(path)
    image_path = fullfile(path(images).folder, path(images).name);
    [filepath,name,ext] = fileparts(image_path);
    distance = vertcat(distance, str2num(name));

    image = imread(image_path);
    img_lab = rgb2lab(image);
    % imshow(i_lab);
    maskedImage = img_lab;
    img_lab = im2double(img_lab);
    img_lab = reshape(img_lab,640*480,3);
    likelihood_orange =mvnpdf([img_lab(:,1) img_lab(:,2) img_lab(:,3)],mean_orange,cov_orange)
    
end