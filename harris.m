function corners = harris(image, alpha, thres)
    gaus = fspecial('gaussian', 7, 1);
    [gdx, gdy] = gradient(gaus);
    ix = imfilter(image, gdx);
    iy = imfilter(image, gdy);
    ix2 = ix.*ix;
    iy2 = iy.*iy;
    ixy = ix.*iy;
    gix2 = imfilter(ix2, gaus);
    giy2 = imfilter(iy2, gaus);
    gixy = imfilter(ixy, gaus);
    det = gix2.*giy2 - gixy.*gixy;
    trace = gix2+giy2;
    cor = det - alpha * trace.^2;
    highcor = cor .* (cor > thres);
    localmax = imdilate(highcor, ones(3));
    corners = highcor .* (highcor == localmax); 
end
