% Camera resolution
d_y = 15.6;
pixel_count_y = 4000;
f = [18, 55];
l = (172+80+100+100-8.5) * 10;
fov_y = atan(d_y./(2*f));

sensor_proj_y = 2*l*tan(fov_y);
pixel_proj_y = sensor_proj_y / pixel_count_y;

fprintf('Using the camera specs:\n');
fprintf('The pixel heights are %f mm (f=18mm), %f mm (f=55mm)\n', pixel_proj_y(1), pixel_proj_y(2));

% With the two segments
seg_y_pixels = [216, 635];
seg_y_length = 200;
seg_x_pixels = [163, 477];
seg_x_length = 150;

pixel_size_y = seg_y_length ./ seg_y_pixels;
pixel_size_x = seg_x_length ./ seg_x_pixels;

fprintf('Using the pattern:\n');
fprintf('The pixel heights are %f mm (f=18mm), %f mm (f=55mm)\n', pixel_size_y(1), pixel_size_y(2));
fprintf('The pixel widths are %f mm (f=18mm), %f mm (f=55mm)\n', pixel_size_x(1), pixel_size_x(2));

% Field of views
a720_s_height = 4.35;
a720_s_width = 5.8;
s9900_s_height = 4.55;
s9900_s_width = 6.17;

a720_f = linspace(5.8, 34.8, 100);
s9900_f = linspace(4.5, 135, 100);

a720_fov_x = atan(a720_s_width/2 ./ a720_f);
a720_fov_y = atan(a720_s_height/2 ./a720_f);

s9900_fov_x = atan(s9900_s_width/2 ./ s9900_f);
s9900_fov_y = atan(s9900_s_height/2 ./s9900_f);

figure;
hold all;
plot(a720_f, a720_fov_x*2*180);
plot(s9900_f, s9900_fov_x*2*180);


plot(a720_f, a720_fov_y*2*180);
plot(s9900_f, s9900_fov_y*2*180);

% Object measurements
pixel_height = d_y / pixel_count_y;
line_h_px = 641;
line_h_mm = 200;
green_duck_h = 458;

line_phi = atan(line_h_px * pixel_height / (2 * 55));

dist = line_h_mm * 55 / (line_h_px * pixel_height);