function min_delay = varAllocate()
global c;
global p;
global lamda;
global N;
global tl;
global tr;
global ts;
global M;
dd = zeros(1,c+1);
dd_temp = zeros(3,c+1);
for x=0:c
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
    
    Ai = zeros(N,x);
    d11 = 0;
    k = 1;
    for i=1:N
        for j=1:N*x
            if j>(i-1)*x && j<=i*x
                Ai(i,k) = A_temp(1,j);
                k = k + 1;
            end
        end
        k = 1;
    end
    for i=1:N
        temp = setdiff(A_temp,Ai(i,:));
        for j=1:size(temp,2)
            d11 = d11 + lamda(i,temp(j))*tr;
        end
    end
    dd_temp(1,x+1) = d1 + d11;
    
    A = unique(A_temp);
    
    lamda_sum = sum(lamda);
    [y,P_temp] = sort(lamda_sum,'descend');
    if isempty(A)
        P = P_temp;
    else
        P = getdiff(P_temp,A);
    end
    
    Bi = zeros(N,c-x);
    Ci = zeros(N,c-x);
    %popularity
    %for k=1:N*(c-x)
    %    [Bi,Ci] = getCacheNode(Bi,Ci,P,lamda,k);
    %end
  
    Bi = allocateCacheNode(Bi, Ci, P, lamda);
 
    d2 = 0;
    d22 = 0;
    for i=1:N
        for j=1:N
            if j==i
                for m=1:(c-x)
                    d22 = d22 + lamda(i,Bi(j,m)) * tl;
                end
            else
                for k=1:(c-x)
                    d2 = d2 + lamda(i,Bi(j,k)) * tr;
                end
            end
        end
    end
    dd_temp(2,x+1) = d2 + d22;
    
    B = zeros(1,N*(c-x)+size(A,2));
    k = 1;
    for i=1:N
        for j=1:(c-x)
            B(k) = Bi(i,j);
            k = k + 1;
        end
    end
    for j=1:size(A,2)
        if isempty(A)
            break;
        end
        B(j+N*(c-x)) = A(j);
    end
    
    MM = zeros(1,M);
    for i=1:M
        MM(i) = i;
    end
    D = getdiff(MM,B);
    
    d3 = 0;
    for i=1:size(D,2)
        d3 = d3 + lamda_sum(1,D(i))*ts;
    end
    dd_temp(3,x+1) = d3;
    dd(1,x+1) = d1 + d11 + d2 + d22 + d3;
end
min_delay = min(dd);
%ratio1 = min(dd)/dd(1,1)
%ratio2 = min(dd)/dd(1, c+1)