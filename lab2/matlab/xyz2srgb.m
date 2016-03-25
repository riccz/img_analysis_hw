function f = xyz2srgb(xyz)

%xyz = xyz/100;
C = [3.241 -1.5374 -0.4986; -0.9692 1.876 0.0416; 0.0556 -0.204 1.057];
rgb = C*xyz';
rgb(rgb<0)=0; % rounding: rgb must be in  [0,1] range
rgb(rgb>1)=1;
srgb = rgb*12.92.*(rgb<=0.0031308)+(1.055*rgb.^(1/2.4)-0.055).*(rgb>0.0031308); % gamma correction

f = srgb;

