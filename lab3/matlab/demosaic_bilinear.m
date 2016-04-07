function img = demosaic_bilinear(bayer)
[W,H] = size(bayer);
img = zeros(W,H,3);
for i=3:W-2 % Skip a border of 2 pixels
    for j=3:H-2
        % Green interp
        if mod(i+j, 2) == 0
            img(i,j, 2) = bayer(i,j);
        else
            img(i,j, 2) = mean([bayer(i-1,j) bayer(i,j-1) bayer(i+1,j) bayer(i,j+1)]);
        end
        
        i_even = mod(i, 2) == 0;
        i_odd = ~i_even;
        j_even = mod(j, 2) == 0;
        j_odd = ~j_even;
        
        % Red interp
        if i_odd && j_even
            img(i,j,1) = bayer(i,j);
        elseif i_odd && j_odd
            img(i,j,1) = mean([bayer(i,j-1) bayer(i,j+1)]);
        elseif i_even && j_even
            img(i,j,1) = mean([bayer(i-1,j) bayer(i+1,j)]);
        else
            img(i,j,1) = mean([bayer(i-1,j-1) bayer(i+1,j-1) bayer(i+1,j+1) bayer(i-1,j+1)]);
        end
        
        % Blue interp
        if i_even && j_odd
            img(i,j,3) = bayer(i,j);
        elseif i_odd && j_odd
            img(i,j,3) = mean([bayer(i-1,j) bayer(i+1,j)]);
        elseif j_even && i_even
            img(i,j,3) = mean([bayer(i,j-1) bayer(i,j+1)]);
        else
            img(i,j,3) = mean([bayer(i-1,j-1) bayer(i+1,j-1) bayer(i+1,j+1) bayer(i-1,j+1)]);
        end
    end
end
end
