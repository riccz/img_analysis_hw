close all; clear all; clc;

half_fov = 33;

imgs_dir = '../lab_22_4_16_manual/';
cil_dir = './cil_imgs/';
mkdir(cil_dir);
for i=1:12
    fname = [imgs_dir 'i' num2str(i) '.bmp'];
    img = imread(fname);
    cil_img = projectIC(img, half_fov);
    imwrite(cil_img, [cil_dir 'c' num2str(i) '.bmp']);
end

last_fname = [cil_dir 'c1.bmp'];
[last_img, last_descr, last_loc] = sift(last_fname);
total_img = last_img;
for i=2:12
    fname = [cil_dir 'c' num2str(i) '.bmp'];
    [img, descr, loc] = sift(fname);    
    [match, num] = match2(last_img, last_descr, last_loc, img, descr, loc, 0.8);    
    [deltax, deltay, compat_count] = ransac_translation(last_loc, loc, match, 50, 3, 3);
    total_img = [total_img, img(:,round(deltax)+1:size(img,2))];
    last_img = img; last_descr = descr; last_loc = loc;
end

figure;
imshow(total_img);
imwrite(total_img, 'panoramic_img.bmp');
