function [last_mean_deltax, last_mean_deltay, last_compatibles_count] = ransac_translation(loc_1, loc_2, matches, n, thresh_x, thresh_y)
m_i = find(matches ~= 0);

last_compatibles_count = 0;
last_mean_deltax = NaN;
last_mean_deltay = NaN;
for i=1:n
    random_m_i = m_i(ceil(rand(1)*(length(m_i)-1))+1);
    delta = loc_2(matches(random_m_i),1:2) - loc_1(random_m_i,1:2);
    all_delta = loc_2(matches(m_i),1:2) - loc_1(m_i,1:2);
    good_delta_i = find(and(...
        abs(all_delta(:,1) - delta(1)) <= thresh_y, ...
        abs(all_delta(:,2) - delta(2)) <= thresh_x));
    good_delta = all_delta(good_delta_i,1:2);
    good_count = size(good_delta, 1);
    if good_count > last_compatibles_count
        last_compatibles_count = good_count;
        last_mean_deltax = mean(good_delta(:,2));
        last_mean_deltay = mean(good_delta(:,1));
    end
end
