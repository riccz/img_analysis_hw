close all; clear all; clc;

load 'exercise_3';
L = 8;

h1 = histogram(i1, L);
h2 = histogram(i2, L);

% Plot of the original histograms
figure;
subplot(1,2,1);
stem(0:L-1, h1);
ylim([0, 0.3]);
xlim([0, 7]);
title('Histogram of i1');
subplot(1,2,2);
stem(0:L-1,h2);
ylim([0, 0.3]);
xlim([0, 7]);
title('Histogram of i2');
print 'histo_original', '-depsc';

% Transformations to equalize i1 and i2
T = zeros(L, 1);
G = zeros(L, 1);
for i=1:L
    T(i) = round((L-1)*sum(h1(1:i)));
    G(i) = round((L-1)*sum(h2(1:i)));
end

% i1 -> i2 Histogram transformation
H = zeros(L, 1);
for r=0:L-1
    s = T(r+1);
    z = find(G >= s, 1) - 1;
    if z > 0 && G(z+1) > s && abs(G(z+1) - s) > abs(G(z) - s)
        z = z-1;
    end
    H(r+1) = z;
end

% Plot the histogram transformations
figure;
hold all;
stairs(0:L-1, T);
stairs(0:L-1, G);
stairs(0:L-1, H);
xlim([0,7]);
ylim([0,7]);
legend('T', 'G', 'H');
print 'histo_transf', '-depsc';

% Equalize i1 like i2
i1_eq = zeros(8,8);
[M,N]=size(i1);
for i=1:M
    for j=1:N
        i1_eq(i,j) = H(i1(i,j)+1);
    end
end

h1_eq = histogram(i1_eq, L);

% Plot new histograms
figure;
subplot(1,2,1);
stem(0:L-1, h1_eq);
ylim([0, 0.3]);
xlim([0, 7]);
title('Equalized histogram of i1');
subplot(1,2,2);
stem(0:L-1,h2);
ylim([0, 0.3]);
xlim([0, 7]);
title('Histogram of i2');
print 'histo_eq', '-depsc';
