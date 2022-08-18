function [descriptors, orientations] = descriptor(img, corners)
    winSize = 16;
    halfSize = winSize / 2;

    gaus = fspecial('gaussian', winSize, 1);
    [ys, xs] = find(corners > 0);

    nkey = size(xs, 1);
    
    img = padarray(img,[halfSize halfSize],0,'both');

    [gmag, gdir] = imgradient(img);
    nidx = gdir < 0;
    gdir(nidx) = gdir(nidx) + 360;

    orientations = zeros(nkey, 1);
    descriptors = zeros(nkey, 128);

    for i = 1:nkey
        x = xs(i) + halfSize;
        y = ys(i) + halfSize;
%         if x <= halfSize || x >= width - halfSize || y <= halfSize || y >= height - halfSize
%             continue;
%         end

        pmag = gmag(y-halfSize:y+halfSize, x-halfSize:x+halfSize);
        pdir = gdir(y-halfSize:y+halfSize, x-halfSize:x+halfSize);

        wpmag = imfilter(pmag, gaus);

        oHist = zeros(1, 36);
        for row = 1: winSize
            for col = 1: winSize
                dir = pdir(row, col);
                mag = wpmag(row, col);
                
                bin = floor(dir/10)+1;
                w = bin - dir/10;
                
                bin1 = mod(bin, 36) + 1;
                bin2 = mod(bin+1, 36) + 1;
                oHist(bin1) = oHist(bin1) + w * mag;
                oHist(bin2) = oHist(bin2) + (1-w) * mag;
            end
        end
        [~, maxDir] = max(oHist);
        
        orient = (maxDir - 1) * 10;
        orientations(i) = orient;
        
        pdir = pdir - orient;
        nidx = pdir < 0;
        pdir(nidx) = pdir(nidx) + 360;
        
        descriptor = zeros(128, 1);
        for row = 1: winSize
            prow = floor((row - 1)/ 4);
            for col = 1: winSize
                pcol = floor((col - 1) / 4);
                
                doffset = (prow * 4 + pcol) * 8;
                
                dir = pdir(row, col);
                mag = wpmag(row, col);

                bin = floor(dir/45)+1;
                w = bin - dir/45;
                
                bin1 = mod(bin, 8) + 1;
                bin2 = mod(bin+1, 8) + 1;
                
                descriptor(doffset + bin1) = descriptor(doffset + bin1) + w * mag;
                descriptor(doffset + bin2) = descriptor(doffset + bin2) + (1 - w) * mag;
            end
        end
        
        descriptor = normalize(descriptor, 'range');
        descriptor(descriptor > 0.2) = 0.2;
        descriptor = normalize(descriptor, 'range');
        descriptors(i, :) = descriptor;

    end

end