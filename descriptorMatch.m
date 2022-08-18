function [i1, i2] = descriptorMatch(desc1, desc2, thres)
    len1 = size(desc1, 1);
    len2 = size(desc2, 1);
    
    maxLen = min([len1, len2]);
    
    i1 = zeros(maxLen, 1);
    i2 = zeros(maxLen, 1);
%     min_dist = zeros(len1, 1);
    
    mi = 0;
    
    for i = 1 : len1
        dist = zeros(len2, 1);
        for j = 1 : len2
            dist(j) = norm(desc1(i, :) - desc2(j, :));
        end
        [min2, min2i] = mink(dist, 2);
        if(min2(1) < thres * min2(2))
            mi = mi + 1;
            i1(mi) = i;
            i2(mi) = min2i(1);
        end
    end
    
    i1 = i1(1:mi);
    i2 = i2(1:mi);
end