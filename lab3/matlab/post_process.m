function [out] = post_process(image)

% - - - Brightness and Gamma - - -
grayim = rgb2gray(image);
grayscale = 0.25/mean(grayim(:));
bright_srgb = min(1,image*grayscale);
clear  grayim

out = bright_srgb.^(1/2.2);