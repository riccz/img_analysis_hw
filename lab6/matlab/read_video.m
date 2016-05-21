function [mov, h, w, k, f_rate] = read_video(fname, MAX_FRAMES)
%create video object
v_obj = VideoReader(fname);

% video parameters
h = v_obj.Height;
w = v_obj.Width;
f_rate = v_obj.FrameRate;

% matlab uses plenty of memory, use a limit on the number of frames
% according to the available resources to avoid out of memory errors
if nargin < 2
    MAX_FRAMES = 400;
end

% Read video frame by frame until available or MAX_FRAMES reached

mov = zeros(h,w,3,MAX_FRAMES, 'uint8'); % 4D matrix to store color video
k=0; %index of last read frame

while hasFrame(v_obj) && k < MAX_FRAMES
    k=k+1;
    vidFrame = readFrame(v_obj);
    mov(:,:,:,k) = vidFrame;
end

mov = mov(:,:,:,1:k); %delete unused matrix part to save memory
end
