img1 = rgb2gray(im2double(imread('assert\human\1.png')));
img2 = rgb2gray(im2double(imread('assert\human\4.png')));
corners1 = harris(img1, 0.05, 1e-6);
corners2 = harris(img2, 0.05, 1e-6);
% [ys, xs] = find(corners > 0);
[desc1, orient1] = descriptor(img1, corners1);
[desc2, orient2] = descriptor(img2, corners2);

[i1, i2] = descriptorMatch(desc1, desc2, 0.9);

[y1, x1] = find(corners1 > 0);
[y2, x2] = find(corners2 > 0);

pts1 = cat(2, x1, y1);
pts2 = cat(2, x2, y2);
pts1 = pts1(i1, :);
pts2 = pts2(i2, :);

showMatchedFeatures(img1, img2, pts1, pts2, 'montage');