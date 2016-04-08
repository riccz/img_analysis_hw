close all; clear all; clc;

test_imgs = {'kodim01.png' 'kodim05.png' 'kodim13.png' 'kodim19.png'};
%test_imgs = {'small_kodim01.png' 'small_kodim05.png' 'small_kodim13.png' 'small_kodim19.png'};

% Perform the demosaicing
demosaic_imgs = cell(1, length(test_imgs));
matlab_demosaic_imgs = cell(1, length(test_imgs));
for i=1:length(test_imgs)
    fname = ['../images/' test_imgs{i}];
    [bayer, bayer3] = create_bayer(fname);
    
    demosaic_imgs{i} = demosaic_bilinear(bayer);
    matlab_demosaic_imgs{i} = double(demosaic(bayer, 'grbg')) ./ 255;
    
    imwrite(demosaic_imgs{i}, ['demosaic_' test_imgs{i}]);
    imwrite(matlab_demosaic_imgs{i}, ['matlab_demosaic_' test_imgs{i}]);
end

% Compute the image differences
C = makecform('srgb2lab');
mean_dists = zeros(1, length(test_imgs));
matlab_mean_dists = zeros(1, length(test_imgs));
for i=1:length(test_imgs)
    fname = ['../images/' test_imgs{i}];
    test_img = double(imread(fname)) ./ 255;
    test_img_lab = applycform(test_img,C);
    
    demosaic_lab = applycform(demosaic_imgs{i}, C);
    matlab_demosaic_lab = applycform(matlab_demosaic_imgs{i}, C);
    
    % Exclude a 2 pixel border from the comparison
    [W, H, ~] = size(test_img);
    test_img_lab = test_img_lab(3:W-2,3:H-2,:);
    demosaic_lab = demosaic_lab(3:W-2,3:H-2,:);
    matlab_demosaic_lab = matlab_demosaic_lab(3:W-2,3:H-2,:);
    
    mean_dists(i) = mean(mean(sqrt(sum((demosaic_lab - test_img_lab).^2, 3))));
    matlab_mean_dists(i) = mean(mean(sqrt(sum((matlab_demosaic_lab - test_img_lab).^2, 3))));
end

fprintf('The demosaiced images have distances:\n');
fprintf('  Image & Linear interpolation & Gradient corrected interpolation \\\\\n');
for i=1:length(test_imgs)
    fprintf(['  ' test_imgs{i} ' & %.3f & %.3f \\\\\n'], mean_dists(i), matlab_mean_dists(i));
end
