close all;
clear all;
clc;

v_obj = VideoReader('video/people.avi');

% video parameters
h = v_obj.Height;
w = v_obj.Width;
f_rate = v_obj.FrameRate;

%f_rate = f_rate * 4;

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

alpha = 0.1;
threshold = 100;
background = zeros(h,w,k,'uint8');
background(:,:,1) = mov(:,:,1);
moving = zeros(h,w,k,'uint8');
for i=2:k
    background(:,:,i) = alpha .* mov(:,:,i-1) + (1-alpha) .* background(:,:,i-1);
    diff = mov(:,:,i) - background(:,:,i-1);
    moving(:,:,i) = (diff.^2 >= threshold) .* 255;
end

%example of empty matrix to place computation output


% play the video
implay(background, f_rate);
implay(moving, f_rate);


