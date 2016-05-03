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
