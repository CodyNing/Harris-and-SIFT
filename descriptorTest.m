img = rgb2gray(im2double(imread('assert\human\1.png')));

corners = harris(img, 0.05, 1e-6);
% [ys, xs] = find(corners > 0);
[descriptors, orientations] = descriptor(img, corners);
% 
% winSize = 16;
% halfSize = winSize / 2;
% gaus = fspecial('gaussian', winSize, 1);
% [ys, xs] = find(corners > 0);
% 
% [gmag, gdir] = imgradient(img);
% 
% x = xs(5);
% y = ys(5);
% 
% pmag = gmag(y-halfSize:y+halfSize, x-halfSize:x+halfSize);
% pdir = gdir(y-halfSize:y+halfSize, x-halfSize:x+halfSize);
% nidx = gdir < 0;
% gdir(nidx) = gdir(nidx) + 360;
% wpmag = imfilter(pmag, gaus);
% 
% oHist = zeros(1, 36);
% for row = 1: winSize
%     for col = 1: winSize
%         dir = pdir(row, col);
%         if dir < 0
%             dir = dir + 360;
%         end
%         mag = wpmag(row, col);
%         bin = floor(dir/10)+1;
%         w = bin - dir/10;
%         oHist(bin) = (1 - w) * mag;
%         oHist(bin+1) = w * mag;
%     end
% end
% [maxMag, maxDir] = max(oHist);
% maxDir = (maxDir - 1) * 10;