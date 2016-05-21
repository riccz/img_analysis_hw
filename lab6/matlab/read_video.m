% Image and Video Analysis (P.Zanuttigh)
% Sample script to read a video file

close all; clear all; clc;

%create video object
v_obj = VideoReader('../video/car1.avi');

% video parameters
h = v_obj.Height;
w = v_obj.Width;
f_rate = v_obj.FrameRate;
fprintf('   width: %d    height: %d   frame rate: %d \n', w, h, f_rate);


% matlab uses plenty of memory, use a limit on the number of frames
% according to the available resources to avoid out of memory errors
MAX_FRAMES = 400;


% Read video frame by frame until available or MAX_FRAMES reached

mov = zeros(h,w,MAX_FRAMES, 'uint8'); % 4D matrix to store color video
k=0; %index of last read frame

while hasFrame(v_obj) && k < MAX_FRAMES
    k=k+1;        
    vidFrame = readFrame(v_obj);
    mov(:,:,k) = rgb2gray(vidFrame);
end

fprintf('%d frames read \n', k);
mov = mov(:,:,1:k); %delete unused matrix part to save memory

winsize = 5;
for i=2:k
    
    c = corner(mov(:,:,i), 'Harris');
    
    c_prev = corner(mov(:,:,i-1), 'Harris');
    [gradx, grady] = imgradientxy(mov(:,:,i));
    gradt = (mov(:,:,i-1) - mov(:,:,i)) ./ 2;
        
    figure;
    imshow(mov(:,:,i));
    hold on;
    scatter(c(:,1), c(:,2), 'rO');
    
    for j=1:size(c, 1)
        window_coords = c(j,:) + [(-floor(winsize/2):floor(winsize/2)).', ...
            (-floor(winsize/2):floor(winsize/2)).'];
        
        Ix = gradx();
        Iy = grady(c(j, 2) + (-floor(winsize/2):floor(winsize/2)));        
        It = gradt(c(j, 2) + (-floor(winsize/2):floor(winsize/2)));        
        
        AtA = [sum(Ix*Ix.'), sum(Ix*Iy.'); sum(Ix*Iy.'), sum(Iy*Iy.')];
        
        %Ab = 
        
    end
    
    
end




%example of empty matrix to place computation output
out = zeros( h,w,3,k,'uint8');

% play the video
implay(mov/255, f_rate);
