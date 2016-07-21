function img_green = pattern_interp(bayer_green)
assert(ismatrix(bayer_green));
assert(isa(bayer_green, 'uint8'));
bayer_green = double(bayer_green);
[H,W] = size(bayer_green);
img_green = zeros(H,W);

for x=0:W-1
    for y=0:H-1
        % Keep the known values
        if mod(x+y, 2) == 0
            img_green(y+1, x+1) = bayer_green(y+1, x+1);
            continue;
        end
        
        if x < 2 || y < 2 || x > W-3 || y > H-3
            warning('Implement on the borders');
            continue;
        end
        
        neighs = [ bayer_green(y,x+1), ...
            bayer_green(y+1,x+2), ...
            bayer_green(y+2,x+1), ...
            bayer_green(y+1,x) ...
            ];
        mean_g = mean(neighs);
        median_g = median(neighs);
        is_geq = neighs >= mean_g;
        
        % Edges
        if sum(is_geq) >= 3 || sum(is_geq) == 1
            img_green(y+1, x+1) = median_g;
            continue;
        end
        
        % Stripes
        if is_geq(1) == is_geq(3)
            X_pos_relative = [ 1,2; ...
                2,1; ...
                -1,-2; ...
                -2,-1; ...
                1,-2; ...
                2,-1; ...
                -1,2; ...
                -2,1 ...
                ];
        else
            % Corners
            if is_geq(3) == is_geq(2)
                X_pos_relative = [ 2,-1; ...
                    1,-2; ...
                    -1,2; ...
                    -2,1 ...
                    ];
            else
                X_pos_relative = [ 2,1; ...
                    1,2; ...
                    -2,-1; ...
                    -1,-2 ...
                    ];
            end
        end
        
        X = zeros(length(X_pos_relative),1);
        for i=1:length(X)
            X(i) = bayer_green(y+X_pos_relative(i,1)+1, ...
                x+X_pos_relative(i,2)+1);
        end
        img_green(y+1,x+1) = clip(neighs, 2*median_g - mean(X));
    end
end
img_green = img_green ./ 255;
end

function G = clip(neighs, x)
sorted_neighs = sort(neighs);
C = sorted_neighs(2);
B = sorted_neighs(3);
if x > B
    G = B;
elseif x < C
    G = C;
else
    G = x;
end
end
