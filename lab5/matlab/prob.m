close all; clear all; clc;

v_obj = VideoReader('../video/chair.avi');

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

% Params
sigma2 = 100;
R = 40;
threshold = 0.75;

G = @(diff) exp(-double(diff).^2 ./ (2*sigma2));


moving = zeros(h,w,k,'uint8');
% Skip the first R frames: too few previous I_k-i
for j=R+1:k
    probs = zeros(h, w, 'double');
    for i=1:R
    diff = mov(:,:,j) - mov(:,:,j-i);
    probs = probs + G(diff) ./ R;
    end
   moving(:,:,j) = (probs <= threshold) .* 255;
end

implay(moving);