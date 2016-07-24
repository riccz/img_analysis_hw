function [out] = post_process(image, xyz2cam)
isuint8 = isa(image, 'uint8');
isuint16 = isa(image, 'uint16');
if isuint8
    image = double(image) ./ 255;
elseif isuint16
    image = double(image) ./ (2^16-1);
end

% Color space conversion
rgb2xyz = [0.4124564, 0.3575761, 0.1804375; ...
    0.2126729, 0.7151522, 0.0721750; ...
    0.0193339, 0.1191920, 0.9503041];
rgb2cam = xyz2cam * rgb2xyz;
rgb2cam = rgb2cam ./ repmat(sum(rgb2cam,2),1,3); % Normalize rows to 1
cam2rgb = inv(rgb2cam);
srgb_im = apply_cmatrix(image, cam2rgb);
srgb_im = max(0,min(srgb_im,1));
clear image;

% - - - Brightness and Gamma - - -
grayim = rgb2gray(srgb_im);
grayscale = 0.25/mean(grayim(:));
bright_srgb = min(1,srgb_im*grayscale);
clear  grayim srgb_im;
out = bright_srgb.^(1/2.2);

if isuint8
    out = uint8(out .* 255);
elseif isuint16
    out = uint16(out .* (2^16-1));
end
end