path=dir('./train_images/*.jpg');

distances = zeros(1);
areas = zeros(1);
for images = 1:length(path)
    image_path = fullfile(path(images).folder, path(images).name);
    [filepath,name,ext] = fileparts(image_path);
    distances = vertcat(distances, str2num(name));

    image = imread(image_path);
    img_lab = rgb2lab(image);
    BW = (img_lab(:,:,1)>=20)&(img_lab(:,:,1)<=90)&(img_lab(:,:,2)>=15)...
        &(img_lab(:,:,2)<=50)&(img_lab(:,:,3)>=10)&(img_lab(:,:,3)<=45);
    stats = regionprops('table',BW,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
    [val1 index1] = max(stats.MajorAxisLength);
    [val2 index2] = max(stats.MinorAxisLength);
    if (index1 ==index2)
        centers  = stats.Centroid(index1,:);
        radii = (stats.MajorAxisLength(index1)+stats.MinorAxisLength(index1))/4 ;
    else
        radii_1 = (stats.MajorAxisLength(index1)+stats.MinorAxisLength(index1))/4;
        radii_2 = (stats.MajorAxisLength(index2)+stats.MinorAxisLength(index2))/4;
        if radii_1>radii_2
            radii = radii_1;
            centers = stats.Centroid(index1,:);
        else
            radii = radii_2;
            centers = stats.Centroid(index2,:);
        end
    end
    areas = vertcat(areas, pi*(radii^2));
end
distances = distances(2:length(distances));
areas = areas(2:length(areas));

%relationship between area we see of the ball and distance
f=fit(areas,distances,'poly4');

%testing
path=dir('./test_images/*.jpg');
for images=1:length(path)
    image_path = fullfile(path(images).folder, path(images).name);
    [filepath,name,ext] = fileparts(image_path);

    image=imread(image_path);
    img_lab = rgb2lab(image);
    BW = (img_lab(:,:,1)>=20)&(img_lab(:,:,1)<=90)&(img_lab(:,:,2)>=15)&...
        (img_lab(:,:,2)<=50)&(img_lab(:,:,3)>=10)&(img_lab(:,:,3)<=45);
    stats = regionprops('table',BW,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
    [val1 index1] = max(stats.MajorAxisLength);
    [val2 index2] = max(stats.MinorAxisLength);
    if (index1 ==index2)
        centers  = stats.Centroid(index1,:);
        radii = (stats.MajorAxisLength(index1)+stats.MinorAxisLength(index1))/4 ;
    else
        radii_1 = (stats.MajorAxisLength(index1)+stats.MinorAxisLength(index1))/4;
        radii_2 = (stats.MajorAxisLength(index2)+stats.MinorAxisLength(index2))/4;
        if radii_1>radii_2
            radii = radii_1;
            centers = stats.Centroid(index1,:);
        else
            radii = radii_2;
            centers = stats.Centroid(index2,:);
        end
    end
    area = pi*(radii^2);
    distance = f.p1*area^4 + f.p2*area^3 + f.p3*area^2 + f.p4*area+f.p5;
    fprintf('\ndistance for test image %d is %d',images, distance);
end