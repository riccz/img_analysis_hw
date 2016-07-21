function img = demosaic_pattern_hue(bayer3, beta)
img_green = pattern_interp(bayer3(:,:,2));
bayer3(:,:,2) = img_green;
img = smooth_hue(bayer3, beta);
end
