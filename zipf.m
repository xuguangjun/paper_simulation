function out = zipf(s, m, size)

sum1 = 0;
pf = zeros(1,size);
out = zeros(1,size);

%���ĸ֮��
for n = 1:m
    pp = 1/n^s;
    sum1 = sum1+pp;
end
%������������
for i = 1:m
    if i == 1
        pf(i) = 1/i^s/sum1;
    else
        pf(i) = pf(i-1) + 1/i^s/sum1;
    end
end
%���������������n
u1 = rand( 1, size );
for n = 1:size
    index = 1;
    while u1(n)>pf(index)
        index = index + 1;
    end
    out(n) = index;
end