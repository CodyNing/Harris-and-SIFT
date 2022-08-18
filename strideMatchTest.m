
img1 = rgb2gray(im2double(imread('assert\object1\1.png')));
img2 = rgb2gray(im2double(imread('assert\object1\4.png')));

winH = size(img1, 1);
winW = size(img1, 2);

[globalmin, localmin] = strideMatch(img1, img2, 10, 1e-6, 0.9, 2, 'same');

imshow(img2);
hold on;

for i = 1: size(localmin, 1)
    rectangle('Position',[localmin(i, 2) localmin(i, 1) winW winH], 'EdgeColor','green');
end
rectangle('Position',[globalmin(2) globalmin(1) winW winH], 'EdgeColor','r');

corners1 = harris(img1, 0.05, 1e-6);
[desc1, orient1] = descriptor(img1, corners1);

for i = 1: size(localmin, 1)
    x = localmin(i, 2);
    y = localmin(i, 1);
    crop = img2(y:y+winH-1, x:x+winW-1);
    
    corners2 = harris(crop, 0.05, 1e-6);
    
    [desc2, orient2] = descriptor(crop, corners2);

    [i1, i2] = descriptorMatch(desc1, desc2, 0.9);

    [y1, x1] = find(corners1 > 0);
    [y2, x2] = find(corners2 > 0);

    pts1 = cat(2, x1, y1);
    pts2 = cat(2, x2, y2);
    pts1 = pts1(i1, :);
    pts2 = pts2(i2, :);
    figure;
    showMatchedFeatures(img1, crop, pts1, pts2, 'montage');
end