function h = histogram_1(img, L)
[M,N] = size(img);
h = zeros(L, 1);
for i=1:M
    for j=1:N
        h(img(i,j)+1) = h(img(i,j)+1) + 1;
    end
end
h = h ./ (M*N);
end
