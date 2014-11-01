clear all;
N = 10;     %number of nodes
c = 10;     %cache size per node
M = 1000;   %number of requests per node
R = 10000;  %requests per node
s = 0.8;    %s para in the zipf distribution

tl = 1;
tr = 30;
ts = 100;

request_temp = randraw('zipf',s,R);
lamda_temp = zeros(1,M);
for i=1:R
    lamda_temp(request_temp(i)) = lamda_temp(request_temp(i)) + 1;
end
lamda = zeros(N,M);
for i=1:N
    temp = randperm(M);
    for j=1:M
        lamda(i,j) = lamda_temp(temp(j));
    end
end

p = zeros(N,M);
for i=1:N
    [y,p(i,:)] = sort(lamda(i,:), 'descend');
end

dd = zeros(1,c);
for x=1:c
    d1 = 0;
    A_temp = zeros(1,N*x);
    k = 1;
    for i=1:N
        for j=1:x
            A_temp(1,k) = p(i,j);
            d1 = d1 + lamda(i,p(i,j))*tl;
            k = k + 1;
        end
    end
    A = unique(A_temp);
    
    lamda_sum = sum(lamda);
    [y,P_temp] = sort(lamda_sum,'descend');
    P = getdiff(P_temp,A);
    
    d2 = 0;
    B = zeros(1,N*(c-x)+size(A,2));
    for k=1:N*(c-x)
        d2 = d2 + lamda_sum(P(k))*tr;
        B(k) = P(k);
    end
    for j=1:size(A,2)
        B(j+N*(c-x)) = A(j);
    end
    
    MM = zeros(1,M);
    for i=1:M
        MM(i) = i;
    end
    D = getdiff(MM,B);
    
    d3 = 0;
    for i=1:size(D,2)
        d3 = d3 + D(i)*ts;
    end
    
    dd(1,x) = d1 + d2 + d3;
end
min(dd)/dd(1,c)


