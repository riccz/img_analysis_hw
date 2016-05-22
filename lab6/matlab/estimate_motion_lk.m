function [motion, c, c_type] = estimate_motion_lk(frame, frame_prev, winsize, corner_max_num, corner_eig_thresh, corner_eigratio_thresh)
% Feature types
FT_CORNER = 1;
FT_EDGE = 2;
FT_UNIF = 3;

frame = rgb2gray(frame);
frame_prev = rgb2gray(frame_prev);

c = corner(frame, 'Harris', corner_max_num);
c_type = zeros(size(c, 1), 1);

[gradx, grady] = imgradientxy(frame);
gradt = (double(frame) - double(frame_prev)) ./ 2;

motion = zeros(size(c,1), 2);
for j=1:size(c, 1)
    window_coords_1 = c(j,2) + (-winsize:winsize);
    window_coords_2 = c(j,1) + (-winsize:winsize);
    
    try
        Ix = gradx(window_coords_1, window_coords_2);
        Iy = grady(window_coords_1, window_coords_2);
        It = gradt(window_coords_1, window_coords_2);
    catch e
        if strcmp(e.identifier, 'MATLAB:badsubscript')
            %warning('Skip a corner too close to the border');
            continue;
        else
            rethrow(e);
        end
    end
    
    Ix_col = reshape(Ix, [], 1);
    Iy_col = reshape(Iy, [], 1);
    It_col = reshape(It, [], 1);
    
    A = [Ix_col, Iy_col];
    b = It_col;
    AtA = transpose(A) * A;
    Atb = transpose(A) * b;
    
    motion(j, :) = linsolve(AtA, -Atb);
    
    % Classify the feature points
    eigs = eig(AtA);
    if any(eigs >= corner_eig_thresh)
        eigs_s = sort(eigs);
        eigratio = eigs_s(2) / eigs_s(1);
        if eigratio < corner_eigratio_thresh
            c_type(j) = FT_CORNER;
        else
            c_type(j) = FT_EDGE;
        end
    else
        c_type(j) = FT_UNIF;
    end
end

% Remove the skipped features
keep = c_type ~= 0;
c_type = c_type(keep);
c = c(keep,:);
motion = motion(keep,:);
end
