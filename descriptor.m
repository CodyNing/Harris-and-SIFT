function [descriptors, orientations] = descriptor(img, corners)
    winSize = 16;
    halfSize = winSize / 2;

    gaus = fspecial('gaussian', winSize, 1);
    [ys, xs] = find(corners > 0);

    nkey = size(xs, 1);

    [height, width] = size(img);

    [gmag, gdir] = imgradient(img);
    nidx = gdir < 0;
    gdir(nidx) = gdir(nidx) + 360;

    orientations = zeros(nkey, 1);
    descriptors = zeros(nkey, 128);

    for i = 1:nkey
        x = xs(i);
        y = ys(i);
        if x <= halfSize || x >= width - halfSize || y <= halfSize || y >= height - halfSize
            continue;
        end

        pmag = gmag(y-halfSize:y+halfSize, x-halfSize:x+halfSize);
        pdir = gdir(y-halfSize:y+halfSize, x-halfSize:x+halfSize);

        wpmag = imfilter(pmag, gaus);

        oHist = zeros(1, 36);
        for row = 1: winSize
            for col = 1: winSize
                dir = pdir(row, col);
                mag = wpmag(row, col);
                %change index
                bin = floor(dir/10)+1;
                w = bin - dir/10;
                oHist(bin) = oHist(bin) + (1 - w) * mag;
                oHist(bin+1) = oHist(bin+1) + w * mag;
            end
        end
        [~, maxDir] = max(oHist);
        orientations(i) = (maxDir - 1) * 10;
        
        descriptor = zeros(128, 1);
        for row = 1: winSize
            prow = floor(row / 4);
            for col = 1: winSize
                pcol = floor(col / 4);
                
                doffset = prow * pcol;
                dir = pdir(row, col);
                mag = wpmag(row, col);

                bin = floor(dir/8)+1;
                w = bin - dir/8;
                descriptor(doffset + bin) = descriptor(doffset + bin) + (1 - w) * mag;
                descriptor(doffset + bin+1) = descriptor(doffset + bin + 1) + w * mag;
            end
        end
        descriptors(i, :) = descriptor;

    end

end