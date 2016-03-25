close all; clear all; clc;

lambdas = 400:5:780;

load 'd65';
d65 = (spline(D65(:,1), D65(:,2), lambdas))';

load 'cmf';
x_mf = (spline(CMF(:,1), CMF(:,2), lambdas))';
y_mf = (spline(CMF(:,1), CMF(:,3), lambdas))';
z_mf = (spline(CMF(:,1), CMF(:,4), lambdas))';

N = d65'*y_mf;

load 'macbeth';
white_sp = (spline(MAC(:,1), MAC(:,20), lambdas))';
yellow_sp = (spline(MAC(:,1), MAC(:,17), lambdas))';

Cyell = yellow_sp ./ white_sp .* d65 ./ N;
yellow_xyz = [Cyell' * x_mf, Cyell' * y_mf, Cyell' * z_mf];
yellow_srgb = xyz2srgb(yellow_xyz) .* 255;

reference_white = [0.950456, 1, 1.088754];
yellow_cielab = xyz2cielab(yellow_xyz, reference_white);

fprintf('The yellow has coords:\n');
fprintf('  XYZ (%f, %f, %f)\n', yellow_xyz(1), yellow_xyz(2), yellow_xyz(3));
fprintf('  sRGB (%f, %f, %f)\n', yellow_srgb(1), yellow_srgb(2), yellow_srgb(3));
fprintf('  LAB (%f, %f, %f)\n', yellow_cielab(1), yellow_cielab(2), yellow_cielab(3));

