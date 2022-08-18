function [globalmin, localmin] = strideMatch(img1, img2, stride, harrisThres, NNratio, noiseSigma, windowMode)
    h1 = size(img1, 1);
    w1 = size(img1, 2);
    h2 = size(img2, 1);
    w2 = size(img2, 2);

    if (h1 < h2 && w1 > w2) || (h1 > h2 && w1 < w2)
        return
    end

    if h1 < h2
        if strcmp(windowMode, 'square')
            winH = max(h1, w1);
            winW = winH;
        elseif strcmp(windowMode, 'same')
            winH = h1;
            winW = w1;    
        else
            error('windowMode incorrect.');
        end
        canH = h2;
        canW = w2;
        win = img1;
        canvas = img2;
    else
        if strcmp(windowMode, 'square')
            winH = max(h2, w2);
            winW = winH;
        elseif strcmp(windowMode, 'same')
            winH = h2;
            winW = w2;
        else
            error('windowMode incorrect.');
        end
        canH = h1;
        canW = w1;
        win = img2;
        canvas = img1;
    end

    N = floor((canW-winW)/stride) + 1;
    M = floor((canH-winH)/stride) + 1;

    diffMap = zeros(M, N);

    winCorn = harris(win, 0.05, 1e-6);
    [winDesc, ~] = descriptor(win, winCorn);

    for i = 1:N
        for j = 1:M
            x = 1 + (i-1) * stride;
            y = 1 + (j-1) * stride;

            crop = canvas(y:y+winH-1, x:x+winW-1);


            cropCorn = harris(crop, 0.05, harrisThres);
            [cropDesc, ~] = descriptor(crop, cropCorn);

            [i1, i2] = descriptorMatch(winDesc, cropDesc, NNratio);

            norms = sqrt(sum( (winDesc(i1, :) - cropDesc(i2, :)).^2, 2 ));

            diffMap(j, i) = sum(norms, 1) / size(i1, 1);
        end
    end

    diffMap = imgaussfilt(diffMap, noiseSigma);

    localmin = imregionalmin(diffMap);

    [y, x] = find(diffMap == min(diffMap(:)), 1, 'first');
    x = 1 + (x-1) * stride;
    y = 1 + (y-1) * stride;
    
    globalmin = [y, x];


    [ys, xs] = find(localmin == 1);
    xs = 1 + (xs-1) * stride;
    ys = 1 + (ys-1) * stride;
    
    localmin = cat(2, ys, xs);
end