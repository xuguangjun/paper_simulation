clear all;
%request type simulation, percent and correlation
N = 3;
M = 1000;
R = 100000;
s = 1.2;

percent = 0.001;
correlation = 0.1;

request_temp = zipf(s, M, R);
lamda_temp = zeros(1, M);

for i = 1:R
    lamda_temp(request_temp(i)) = lamda_temp(request_temp(i)) + 1;
end

lamda1 = sort(lamda_temp, 'descend');
lamda = zeros(N, M);
lamda(1, :) = lamda1;

for i = 2:N
    lamda(i, :) = correlationRequest(lamda1, percent, correlation);
end
same = M * percent;
num =  50 - same;
x = zeros(1, num);
for i = 1:num
    x(i) = i + same;
end
plot(x,lamda(1,same+1:50),'b-', x,lamda(2,same+1:50),'g-', x,lamda(3,same+1:50),'r-')%, x,lamda(4,same+1:50), 'y-', x,lamda(5,same+1:50),'k-');
hold on;
