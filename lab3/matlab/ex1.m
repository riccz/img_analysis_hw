close all; clear all; clc;

test_imgs = {'kodim01.png' 'kodim05.png' 'kodim13.png' 'kodim19.png'};
sh_beta = 128;

% Perform the demosaicing
demosaic_imgs = cell(1, length(test_imgs));
matlab_demosaic_imgs = cell(1, length(test_imgs));
prsh_demosaic_imgs = cell(1, length(test_imgs));
parfor i=1:length(test_imgs)
    fname = ['../images/' test_imgs{i}];
    [bayer, bayer3] = create_bayer(fname);
    
    matlab_demosaic_imgs{i} = demosaic(bayer, 'grbg');
    demosaic_imgs{i} = demosaic_linear(bayer);
    prsh_demosaic_imgs{i} = demosaic_pattern_hue(bayer3, sh_beta);
    
    imwrite(matlab_demosaic_imgs{i}, ['matlab_demosaic_' test_imgs{i}]);
    imwrite(demosaic_imgs{i}, ['demosaic_' test_imgs{i}]);
    imwrite(prsh_demosaic_imgs{i}, ['prsh_demosaic_' test_imgs{i}]);
end

% Compute the image differences
C = makecform('srgb2lab');
mean_dists = zeros(1, length(test_imgs));
matlab_mean_dists = zeros(1, length(test_imgs));
prsh_mean_dists = zeros(1, length(test_imgs));
for i=1:length(test_imgs)
    fname = ['../images/' test_imgs{i}];
    test_img = imread(fname);
    test_img_lab = applycform(test_img,C);
    
    demosaic_lab = applycform(demosaic_imgs{i}, C);
    matlab_demosaic_lab = applycform(matlab_demosaic_imgs{i}, C);
    prsh_demosaic_lab = applycform(prsh_demosaic_imgs{i}, C);
    
    mean_dists(i) = mean(mean(sqrt(sum((demosaic_lab - test_img_lab).^2, 3))));
    matlab_mean_dists(i) = mean(mean(sqrt(sum((matlab_demosaic_lab - test_img_lab).^2, 3))));
    prsh_mean_dists(i) = mean(mean(sqrt(sum((prsh_demosaic_lab - test_img_lab).^2, 3))));
end

fprintf('The demosaiced images have distances:\n');
fprintf('  Image & Linear interpolation & Gradient corrected interpolation & Pattern recognition and smooth hue transition interpolation \\\\\n');
for i=1:length(test_imgs)
    fprintf(['  ' test_imgs{i} ' & %.3f & %.3f & %.3f \\\\\n'], mean_dists(i), matlab_mean_dists(i), prsh_mean_dists(i));
end
