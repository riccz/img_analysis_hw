close all; clear all; clc;

test_imgs = {'kodim01.png' 'kodim05.png' 'kodim13.png' 'kodim19.png'};
for i=1:length(test_imgs)
    fname = ['../images/' test_imgs{i}];
    dstname = ['../images/small_' test_imgs{i}]
    img = imread(fname);
    [W, H, ~] = size(img);
    center_img = img(floor(W/2)-9:floor(W/2)+10, floor(H/2)-9:floor(H/2)+10, :);
    imwrite(center_img, dstname);
end
% 
% dng_imgs = {'DEI_park.dng' 'macbeth_gray.dng' 'poster.dng' ...
%     'students2.dng' 'macbeth_color.dng' 'map.dng' ...
%     'students1.dng' 'students3.dng'};
% for i=1:length(dng_imgs)
%     fname = ['../images/' dng_imgs{i}];
%     dstname = ['../images/small_' dng_imgs{i}]
%     img = imread(fname);
%     [W, H, ~] = size(img);
%     center_img = img(floor(W/2)-9:floor(W/2)+10, floor(H/2)-9:floor(H/2)+10, :);
%     imwrite(center_img, dstname);
% end