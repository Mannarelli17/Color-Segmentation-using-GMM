image = imread('./test_images/1.jpg');
figure(1);
imshow(image);
n = size(image, 1);
m = size(image, 2);
display(n);
display(m);
image = reshape(image, n*m, 3);
image = reshape(image, n, m, 3);
if  n == 480
    image = imrotate(image, 90);
end
figure(2);
imshow(image);
n = size(image, 1);
m = size(image, 2);
display(n);
display(m);