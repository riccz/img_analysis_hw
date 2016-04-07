function colormask = wbmask(m,n,wbmults,align)

% wb_multipliers = (meta_info.AsShotNeutral).^-1;
% wb_multipliers = wb_multipliers/wb_multipliers(2);
% mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,’rggb’);
% balanced_bayer = lin_bayer .* mask;

% COLORMASK = wbmask(M,N,WBMULTS,ALIGN)
%
% Makes a white-balance multiplicative mask for an image of size m-by-n
% with RGB while balance multipliers WBMULTS = [R_scale G_scale B_scale].
% ALIGN is string indicating Bayer arrangement: ’rggb’,’gbrg’,’grbg’,’bggr’
colormask = wbmults(2)*ones(m,n); %Initialize to all green values
switch align
case 'rggb'
colormask(1:2:end,1:2:end) = wbmults(1); %r
colormask(2:2:end,2:2:end) = wbmults(3); %b
case 'bggr'
colormask(2:2:end,2:2:end) = wbmults(1); %r
colormask(1:2:end,1:2:end) = wbmults(3); %b
case 'grbg'
colormask(1:2:end,2:2:end) = wbmults(1); %r
colormask(1:2:end,2:2:end) = wbmults(3); %b
case 'gbrg'
colormask(2:2:end,1:2:end) = wbmults(1); %r
colormask(1:2:end,2:2:end) = wbmults(3); %b
end
end