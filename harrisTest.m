img = rgb2gray(im2double(imread('assert\human\1.png')));
corners = harris(img, 0.05, 1e-6);
[y, x] = find(corners > 0);
imshow(img);
hold on;
plot(x, y, 'x', 'Color', 'red');
