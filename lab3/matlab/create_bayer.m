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
assert(isa(img, 'uint8'));
assert(ndims(img) == 3);
[h, w, cc] = size(img);
assert(mod(h, 2) == 0 && mod(w, 2) == 0);
assert(cc == 3);

%create matrices for the output data
bayer = zeros(h,w);
bayer = uint8(bayer);
bayer3 = zeros(h,w,3);
bayer3 = uint8(bayer3);

% extract the data 
for y= 0:h/2-1
    for x= 0:w/2-1
        bayer(2*y+1,2*x+1) =  img(2*y+1,2*x+1,2);
        bayer(2*y+2,2*x+1) = img(2*y+2,2*x+1,3);
        bayer(2*y+1,2*x+2) = img(2*y+1,2*x+2,1);
        bayer(2*y+2,2*x+2) = img(2*y+2,2*x+2,2);
        
        bayer3(2*y+1,2*x+1,2) =  img(2*y+1,2*x+1,2);
        bayer3(2*y+2,2*x+1,3) = img(2*y+2,2*x+1,3);
        bayer3(2*y+1,2*x+2,1) = img(2*y+1,2*x+2,1);
        bayer3(2*y+2,2*x+2,2) = img(2*y+2,2*x+2,2);
    end
end

% show the resulting bayer masks
%imshow(bayer);
%figure;
%imshow(bayer3);
        
%uncomment to write data to file
%imwrite(bayer,'bayer.png');

end