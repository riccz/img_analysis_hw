close all; clear all; clc;

half_fov = 33;

imgs_dir = '../lab_22_4_16_manual/';
cil_dir = './cil_imgs/';
mkdir(cil_dir);
% Convert in cilindrical coords
for i=1:12
    fname = [imgs_dir 'i' num2str(i) '.bmp'];
    img = imread(fname);
    cil_img = projectIC(img, half_fov);
    imwrite(cil_img, [cil_dir 'c' num2str(i) '.bmp']);
end

% Match the SIFT features
match_thresh = 0.7;
ransac_n = 100;
ransac_thresh_x = 20;
ransac_thresh_y = ransac_thresh_x;
deltas = [];
for i=1:11
    fname1 = [cil_dir 'c' num2str(i) '.bmp'];
    fname2 = [cil_dir 'c' num2str(i+1) '.bmp'];
    
    [img1, descr1, loc1] = sift(fname1);
    [img2, descr2, loc2] = sift(fname2);
    
    [match, num] = match2(img1, descr1, loc1, img2, descr2, loc2, match_thresh);
    
    [deltax, deltay, compat_count] = ransac_translation(loc1, loc2, match, ransac_n, ransac_thresh_x, ransac_thresh_y);
    deltas(i+1,:) = [deltax, deltay];
end

% Merge the images
total_image = imread('cil_imgs/c1.bmp');
for i=2:12
    half_deltax = round(deltas(i,1) / 2);
    cropped_total = imcrop(total_image, [0, 0, size(total_image, 2) + half_deltax, size(total_image, 1)]);
    cropped_img = imcrop(imread(['cil_imgs/c' num2str(i) '.bmp']), [-half_deltax, 0, Inf, Inf]);
    total_image = appendimages(cropped_total, cropped_img);
end
imwrite(total_image, 'panoramic_img.bmp');
