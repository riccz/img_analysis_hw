close all; clear all; clc;

[mov, H, W, K, f_rate] = read_video('../video/car1.avi');

% Feature types
FT_CORNER = 1;
FT_EDGE = 2;
FT_UNIF = 3;

% Params
winsize = 7;
corner_eig_thresh = 10000;
corner_eigratio_thresh = 10;
corner_max_num = 50;
uv_visualization_scale = 100;

out = zeros(H,W,3,K, 'uint8');
for k=2:K-1
    frame = mov(:,:,:,k);
    frame_prev = mov(:,:,:,k-1);
    frame_next = mov(:,:,:,k+1);
    [motion, feats, f_type] = estimate_motion_lk(frame, frame_prev, frame_next, winsize, corner_max_num, corner_eig_thresh, corner_eigratio_thresh);
    
    outframe = frame;
    corners = feats(f_type == FT_CORNER,:);
    if ~isempty(corners)
        outframe = insertMarker(outframe, corners, 'Color', 'green');
        uv = motion(f_type == FT_CORNER,:);
        
        linecoords = [corners, corners + uv_visualization_scale .* uv];
        outframe = insertShape(outframe, 'Line', linecoords, 'Color', 'green');
    end
    
    edges = feats(f_type == FT_EDGE,:);
    if ~isempty(edges)
        outframe = insertMarker(outframe, edges, 'Color', 'blue');
        uv = motion(f_type == FT_EDGE,:);
        
        linecoords = [edges, edges + uv_visualization_scale .* uv];
        outframe = insertShape(outframe, 'Line', linecoords, 'Color', 'blue');
    end
    
    unifs = feats(f_type == FT_UNIF,:);
    if ~isempty(unifs)
        outframe = insertMarker(outframe, unifs, 'Color', 'red');
        uv = motion(f_type == FT_UNIF,:);
        
        linecoords = [unifs, unifs + uv_visualization_scale .* uv];
        outframe = insertShape(outframe, 'Line', linecoords, 'Color', 'red');
    end
    
    out(:,:,:,k) = outframe;
end

implay(out);

% car1
imwrite(out(:,:,:,112), 'car1_example.png');

% v = VideoWriter('out.mp4', 'MPEG-4');
% open(v)
% writeVideo(v,out);
% close(v);
