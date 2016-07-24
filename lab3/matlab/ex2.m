close all; clear all; clc;

dng_imgs = {'DEI_park.dng', 'macbeth_color.dng', ...
    'macbeth_gray.dng', 'map.dng', 'poster.dng', ...
    'students1.dng', 'students2.dng', 'students3.dng'};

parfor i=1:length(dng_imgs)
    fname = ['../images/' dng_imgs{i}];
    bayer = read_dng(fname);
    
    % Convert rggb -> grbg (+1 column at the beginning and end)
    [W, H, ~] = size(bayer);
    bayer = [zeros(W, 1), bayer, zeros(W, 1)];
    
    bayer = uint8(bayer .* 255); % Convert to uint8 to use the same code
    demosaic_img = demosaic_linear(bayer);
    matlab_demosaic_img = double(demosaic(bayer, 'grbg')) ./ 255;
    
    % Remove the extra columns
    demosaic_img = demosaic_img(:, 2:H+1, :);
    matlab_demosaic_img = matlab_demosaic_img(:, 2:H+1, :);
    
    % Postprocessing
    final_img = post_process(demosaic_img);
    matlab_final_img = post_process(matlab_demosaic_img);
    
    imwrite(final_img, ['demosaic_' dng_imgs{i} '.tiff']);
    imwrite(matlab_final_img, ['matlab_demosaic_' dng_imgs{i} '.tiff']);
    fprintf([dng_imgs{i} ' OK\n']);
end
