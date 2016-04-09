function [bayer] = read_dng(filename)

%set the bayer mask type
bayer_type = 'rggb';

% - - - Reading file - - -
    warning off MATLAB:tifflib:TIFFReadDirectory;
    t = Tiff(filename,'r');
    offsets = getTag(t,'SubIFD');
    setSubDirectory(t,offsets(1));
    raw = read(t);
    close(t);
    meta_info = imfinfo(filename);
    x_origin = meta_info.SubIFDs{1}.ActiveArea(2)+1;
    width = meta_info.SubIFDs{1}.DefaultCropSize(1);
    y_origin = meta_info.SubIFDs{1}.ActiveArea(1)+1;
    height = meta_info.SubIFDs{1}.DefaultCropSize(2);
    raw =double(raw(y_origin:y_origin+height-1,x_origin:x_origin+width-1));
    
    % - - - Linearize - - -
    if isfield(meta_info.SubIFDs{1},'LinearizationTable')
        ltab=meta_info.SubIFDs{1}.LinearizationTable;
        raw = ltab(raw+1);
    end
    black = meta_info.SubIFDs{1}.BlackLevel(1);
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
    
    % - - - Color Correction Matrix from DNG Info - - -
    %temp = meta_info.ColorMatrix2;
   % xyz2cam = reshape(temp,3,3)';