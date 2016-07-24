close all; clear all; clc;

dng_imgs = {'DEI_park.dng', 'macbeth_color.dng', ...
    'macbeth_gray.dng', 'map.dng', 'poster.dng', ...
    'students1.dng', 'students2.dng', 'students3.dng'};

sh_beta = 2^15;

parfor i=1:length(dng_imgs)
    fname = ['../images/' dng_imgs{i}];
    [bayer, bayer3, croparea, xyz2cam] = read_dng(fname);
    
    % Convert rggb -> grbg (-1 column at the beginning)
    [W, H, ~] = size(bayer);
    bayer = bayer(:, 2:end);
    bayer3 = bayer3(:, 2:end, :);
    croparea([2,4]) = croparea([2,4]) - 1;
    
    % Demosaic
    matlab_demosaic_img = demosaic(bayer, 'grbg');
    demosaic_img = demosaic_linear(bayer);
    prsh_demosaic_img = demosaic_pattern_hue(bayer3, sh_beta);
    
    % Crop the images
    demosaic_img = demosaic_img(croparea(1):croparea(3), croparea(2):croparea(4), :);
    matlab_demosaic_img = matlab_demosaic_img(croparea(1):croparea(3), croparea(2):croparea(4), :);
    prsh_demosaic_img = prsh_demosaic_img(croparea(1):croparea(3), croparea(2):croparea(4), :);
    
    % Postprocessing
    final_img = post_process(demosaic_img, xyz2cam);
    matlab_final_img = post_process(matlab_demosaic_img, xyz2cam);
    prsh_final_img = post_process(prsh_demosaic_img, xyz2cam);
    
    imwrite(final_img, ['demosaic_' strrep(dng_imgs{i}, '.dng', '.jpg')], ...
        'BitDepth', 8, 'Mode', 'lossy', 'Quality', 90);
    imwrite(matlab_final_img, ['matlab_demosaic_' strrep(dng_imgs{i}, '.dng', '.jpg')], ...
        'BitDepth', 8, 'Mode', 'lossy', 'Quality', 90);
    imwrite(prsh_final_img, ['prsh_demosaic_' strrep(dng_imgs{i}, '.dng', '.jpg')], ...
        'BitDepth', 8, 'Mode', 'lossy', 'Quality', 90);
    fprintf([dng_imgs{i} ' OK\n']);
end
