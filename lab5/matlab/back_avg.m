close all;
clear all;
clc;

v_obj = VideoReader('../video/chair.avi');

% video parameters
h = v_obj.Height;
w = v_obj.Width;
f_rate = v_obj.FrameRate;

MAX_FRAMES = 400;

mov = zeros(h,w,MAX_FRAMES, 'uint8'); % 2D grayscale + time
k=0; %index of last read frame
while hasFrame(v_obj) && k < MAX_FRAMES
    k=k+1;        
    vidFrame = readFrame(v_obj);
    mov(:,:,k) = rgb2gray(vidFrame);
end

fprintf('%d frames read \n', k);
mov = mov(:,:,1:k); %delete unused matrix part to save memory

% Params
alpha = 0.5;
threshold = 130;

background = zeros(h,w,k,'uint8');
background(:,:,1) = mov(:,:,1);
moving = zeros(h,w,k,'uint8');
for i=2:k
    background(:,:,i) = alpha .* mov(:,:,i-1) + (1-alpha) .* background(:,:,i-1);
    diff = mov(:,:,i) - background(:,:,i);
    moving(:,:,i) = (diff.^2 > threshold) .* 255;
end

imwrite(mov(:,:,56), 'fast_motion_orig_prev.png');
imwrite(mov(:,:,57), 'fast_motion_orig.png');
imwrite(moving(:,:,57), 'fast_motion_back.png');

% play the video
implay(background, f_rate);
implay(moving, f_rate);


