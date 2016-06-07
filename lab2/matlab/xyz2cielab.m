function cielab = xyz2cielab(xyz_coords, xyz_white)
xyz_rel = xyz_coords ./ xyz_white;
cielab(1) = 116*f(xyz_rel(2)) - 16;
cielab(2) = 500*(f(xyz_rel(1)) - f(xyz_rel(2)));
cielab(3) = 200*(f(xyz_rel(2)) - f(xyz_rel(3)));
end

function f_t = f(t)
if t > (6/29)^3
    f_t = t^(1/3);
else
    f_t = 1/3 * (29/6)^2 * t + 4/29;
end
end
