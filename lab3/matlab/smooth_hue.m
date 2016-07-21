function img = smooth_hue(bayer3, beta)
assert(isscalar(beta));
assert(ndims(bayer3) == 3);
assert(isa(bayer3, 'uint8'));
bayer3 = double(bayer3);
[H,W,C] = size(bayer3);
assert(C == 3);
img = zeros(H, W, 3);

img(:,:,2) = bayer3(:,:,2);
G = (bayer3(:,:,2)+ beta);
B = (bayer3(:,:,3) + beta) ./ G;
R = (bayer3(:,:,1) + beta) ./ G;

% Blue
for x=0:W-1
    for y=0:H-1
        x_even = (mod(x,2) == 0);
        y_even = (mod(y,2) == 0);
        x_odd = ~x_even;
        y_odd = ~y_even;
        
        % Keep the known values
        if y_odd && x_even
            img(y+1,x+1,3) = bayer3(y+1,x+1,3);
            continue;
        end
        
        if x_even && y_even
            if y == 0
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * B(y+2,x+1);
            elseif y == H-1
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * B(y,x+1);
            else
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * mean([B(y,x+1), B(y+2,x+1)]);
            end
            continue;
        end
        
        if x_odd && y_odd
            if x == 0
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * B(y+1,x+2);
            elseif x == W-1
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * B(y+1,x);
            else
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * mean([B(y+1,x), B(y+1,x+2)]);
            end
            continue;
        end
        
        if x_odd && y_even
            if x == W-1 && y == H-1
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * B(y,x);
            elseif x == W-1 && y == 0
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * B(y+2,x);
            elseif x == W-1
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * mean([B(y,x), B(y+2,x)]);
            elseif y == H-1
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * mean([B(y,x), B(y,x+2)]);
            elseif y == 0
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * mean([B(y+2,x), B(y+2,x+2)]);
            else
                img(y+1,x+1,3) = -beta + G(y+1,x+1) * mean([B(y,x), B(y+2,x+2), B(y,x+2), B(y+2,x)]);
            end
            continue;
        end
    end
end

% Red
for x=0:W-1
    for y=0:H-1
        x_even = (mod(x,2) == 0);
        y_even = (mod(y,2) == 0);
        x_odd = ~x_even;
        y_odd = ~y_even;
        
        % Keep the known values
        if y_even && x_odd
            img(y+1,x+1,1) = bayer3(y+1,x+1,1);
            continue;
        end
        
        if x_odd && y_odd
            if y == 0
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * R(y+2,x+1);
            elseif y == H-1
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * R(y,x+1);
            else
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * mean([R(y,x+1), R(y+2,x+1)]);
            end
            continue;
        end
        
        if x_even && y_even
            if x == 0
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * R(y+1,x+2);
            elseif x == W-1
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * R(y+1,x);
            else
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * mean([R(y+1,x), R(y+1,x+2)]);
            end
            continue;
        end
        
        if x_even && y_odd
            if x == W-1 && y == H-1
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * R(y,x);
            elseif x == 0 && y == H-1
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * R(y,x+2);
            elseif x == W-1
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * mean([R(y,x), R(y+2,x)]);
            elseif y == H-1
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * mean([R(y,x), R(y,x+2)]);
            elseif x == 0
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * mean([R(y+2,x+2), R(y,x+2)]);
            else
                img(y+1,x+1,1) = -beta + G(y+1,x+1) * mean([R(y,x), R(y+2,x+2), R(y,x+2), R(y+2,x)]);
            end
            continue;
        end
    end
end
img = uint8(img);
end
