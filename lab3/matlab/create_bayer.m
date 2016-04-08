% Read an image and extract the data corresponding to the bayer mask used
% to create it. The function assumes the GRBG pattern, i.e.,
% |GR|
% |BG|

% filename: file with the input image
% bayer: bayer mask stored in a single channel image
% bayer: bayer mask stored in 3 channels image with the missing values set
% to 0



function [bayer bayer3] = create_bayer(filename)

%read image
img = imread(filename);
[h, w, cc] = size(img);

%create matrices for the output data
bayer = zeros(h,w);
bayer = uint8(bayer);
bayer3 = zeros(h,w,3);
bayer3 = uint8(bayer3);

% extract the data 
for y= 1:2:h
    for x= 1:2:w
        bayer(y,x) =  img(y,x,2);
        bayer(y+1,x) = img(y+1,x,3);
        bayer(y,x+1) = img(y,x+1,1);
        bayer(y+1,x+1) = img(y+1,x+1,2);
    end
end

for y= 1:2:h
    for x= 1:2:w
        bayer3(y,x,:) = [0 img(y,x,2) 0 ];
        bayer3(y+1,x,:) = [0 0 img(y+1,x,3) ];
        bayer3(y,x+1,:) = [ img(y,x+1,1) 0 0 ];
        bayer3(y+1,x+1,:) = [0 img(y+1,x+1,2) 0 ];
    end
end

% show the resulting bayer masks
%imshow(bayer);
%figure;
%imshow(bayer3);
        
%uncomment to write data to file
%imwrite(bayer,'bayer.png');

end