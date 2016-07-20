function img = demosaic_linear(bayer)
assert(ismatrix(bayer));
assert(isa(bayer, 'uint8'));
bayer = double(bayer);
[H,W] = size(bayer);
img = zeros(H,W,3);

for i=1:H
    for j=1:W
        % Green
        if mod(i+j, 2) == 0 % Copy the green pixels
            img(i,j, 2) = bayer(i,j);
        elseif i > 1 && j > 1 && i < H && j < W % Use 4 neigh. except for the border
            img(i,j, 2) = mean([bayer(i-1,j) bayer(i,j-1) bayer(i+1,j) bayer(i,j+1)]);
        elseif j == 1 && i > 1 && i < H % Left border
            img(i,j,2) = mean([bayer(i+1,j), bayer(i-1,j), bayer(i,j+1)]);
        elseif j == W && i > 1 && i < H % Right border
            img(i,j,2) = mean([bayer(i+1,j), bayer(i-1,j), bayer(i,j-1)]);
        elseif i == 1 && j > 1 && j < W % Top border
            img(i,j,2) = mean([bayer(i+1,j), bayer(i,j-1), bayer(i,j+1)]);
        elseif i == H && j > 1 && j < W % Bottom border
            img(i,j,2) = mean([bayer(i-1,j), bayer(i,j-1), bayer(i,j+1)]);
        elseif i == 1 && j == 1 % Top-left corner
            error('Should always be green');
        elseif i == 1 && j == W % Top-right corner
            img(i,j,2) = mean([bayer(i+1,j), bayer(i,j-1)]);    
        elseif j == 1 && i == H % Bottom-left corner
            img(i,j,2) = mean([bayer(i-1,j), bayer(i,j+1)]);
        elseif j == W && i == H % Bottom-right corner
            img(i,j,2) = mean([bayer(i-1,j), bayer(i,j-1)]);
        else
            error('Missing case');
        end
       
        i_even = mod(i, 2) == 0;
        i_odd = ~i_even;
        j_even = mod(j, 2) == 0;
        j_odd = ~j_even;
        
        % Red
        if i_odd && j_even % Copy the red pixels
            img(i,j,1) = bayer(i,j);
        elseif i_odd && j_odd % Blue column, red row
            if j == 1
                img(i,j,1) = bayer(i,j+1);
            elseif j == W
                img(i,j,1) = bayer(i,j-1);
            else
                img(i,j,1) = mean([bayer(i,j-1) bayer(i,j+1)]);
            end
        elseif i_even && j_even % Red column
            if i < H
                img(i,j,1) = mean([bayer(i-1,j) bayer(i+1,j)]);
            else % Last row
                img(i,j,1) = bayer(i-1,j);
            end
        else % Blue column, blue row
            if j > 1 && j < W && i < H
                img(i,j,1) = mean([bayer(i-1,j-1) bayer(i+1,j-1) bayer(i+1,j+1) bayer(i-1,j+1)]);
            elseif j == 1 && i < H % First column
                img(i,j,1) = mean([bayer(i+1,j+1) bayer(i-1,j+1)]);
            elseif j == W && i < H % Last column
                img(i,j,1) = mean([bayer(i+1,j-1) bayer(i-1,j-1)]);
            elseif i == H && j > 1 && j < W % Bottom row
                img(i,j,1) = mean([bayer(i-1,j-1) bayer(i-1,j+1)]);
            elseif i == H && j == 1 % Bottom-left corner
                img(i,j,1) = bayer(i-1,j+1);
            elseif i == H && j == W % Bottom-right corner
                img(i,j,1) = bayer(i-1,j-1);
            else
                error('Missing case');
            end
        end
              
        % Blue
        if i_even && j_odd % Copy the blue pixels
            img(i,j,3) = bayer(i,j);
        elseif i_odd && j_odd % Blue column
            if i < H && i > 1
                img(i,j,3) = mean([bayer(i-1,j) bayer(i+1,j)]);
            elseif i == H
                img(i,j,3) = bayer(i-1,j);
            else
                img(i,j,3) = bayer(i+1,j);
            end
        elseif j_even && i_even % Red column, blue row
            if j == 1
                img(i,j,3) = bayer(i,j+1);
            elseif j == W
                img(i,j,3) = bayer(i,j-1);
            else
                img(i,j,3) = mean([bayer(i,j-1) bayer(i,j+1)]);
            end
        else % Red column, red row
            if i > 1 && i < H && j < W % Inside
                img(i,j,3) = mean([bayer(i-1,j-1) bayer(i+1,j-1) bayer(i+1,j+1) bayer(i-1,j+1)]);
            elseif i == 1 && j < W % Top border
                img(i,j,3) = mean([bayer(i+1,j-1) bayer(i+1,j+1)]);
            elseif i == H && j < W % Bottom border
                img(i,j,3) = mean([bayer(i-1,j-1) bayer(i-1,j+1)]);
            elseif i > 1 && i < H && j == W % Right border
                img(i,j,3) = mean([bayer(i-1,j-1) bayer(i+1,j-1)]);
            elseif j == W && i == 1 % Top-right corner
               img(i,j,3) = bayer(i+1,j-1);
            elseif j == W && i == H % Bottom-right corner
                img(i,j,3) = bayer(i-1,j-1);
            else
                error('Missing case');
            end
        end
    end
end

img = img ./ 255; % Return an image with pixels in [0,1]
end
