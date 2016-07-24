function [bayer, bayer3, croparea, xyz2cam] = read_dng(filename)

%set the bayer mask type
bayer_type = 'rggb';

% - - - Reading file - - -
warning('off', 'MATLAB:imagesci:tiffmexutils:libtiffWarning');
t = Tiff(filename,'r');
offsets = getTag(t,'SubIFD');
setSubDirectory(t,offsets(1));
raw = read(t);
close(t);
warning('on', 'MATLAB:imagesci:tiffmexutils:libtiffWarning');
assert(isa(raw, 'uint16'));

meta_info = imfinfo(filename);
x_origin = meta_info.SubIFDs{1}.ActiveArea(2) + 1;
width = meta_info.SubIFDs{1}.ActiveArea(4);
y_origin = meta_info.SubIFDs{1}.ActiveArea(1) + 1;
height = meta_info.SubIFDs{1}.ActiveArea(3);
raw =double(raw(y_origin:y_origin+height-1,x_origin:x_origin+width-1));

croparea([2,1]) = meta_info.SubIFDs{1}.DefaultCropOrigin + 1;
croparea([4,3]) = meta_info.SubIFDs{1}.DefaultCropSize + croparea([2,1]) - 1;

% - - - Linearize - - -
if isfield(meta_info.SubIFDs{1},'LinearizationTable')
    ltab=meta_info.SubIFDs{1}.LinearizationTable;
    raw = ltab(raw+1);
end
black = meta_info.SubIFDs{1}.BlackLevel(1);
assert(all(meta_info.SubIFDs{1}.BlackLevel == black));
saturation = meta_info.SubIFDs{1}.WhiteLevel;
lin_bayer = (raw-black)/(saturation-black);
lin_bayer = max(0,min(lin_bayer,1));
clear raw

% - - - White Balance - - -
wb_multipliers = (meta_info.AsShotNeutral).^-1;
wb_multipliers = wb_multipliers/wb_multipliers(2);
mask = wbmask(height,width,wb_multipliers,bayer_type);
bayer = lin_bayer .* mask;
clear lin_bayer mask

% Reconvert to uint16
bayer = uint16(bayer .* (2^16-1));

% Split the CFA components
bayer3 = uint16(zeros(height, width, 3));
bayer3(1:2:end,1:2:end,1) = bayer(1:2:end,1:2:end);
bayer3(2:2:end,2:2:end,3) = bayer(2:2:end,2:2:end);
bayer3(1:2:end,2:2:end,2) = bayer(1:2:end,2:2:end);
bayer3(2:2:end,1:2:end,2) = bayer(2:2:end,1:2:end);

% - - - Color Correction Matrix from DNG Info - - -
xyz2cam_ = meta_info.ColorMatrix2;
xyz2cam = reshape(xyz2cam_,3,3)';
