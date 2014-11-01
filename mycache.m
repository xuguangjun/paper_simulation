clear all;
%this is the main simulation loop
N = 10;     %number of nodes
c = 5;     %cache size per node
M = 1000;   %number of contents
R = 100000;  %requests per node
%s = [0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55];    %s para in the zipf distribution per node
s = 1.7;

tl = 1;     %time delay when request a item that locally valiable
tr = 6;    %time delay when request a item that group cache are valiable
ts = 63;   %time delay when request a item that only server has

percent = 0.01;     %amout of same popular items among all the nodes

%{
lamda = zeros(N,M); 
for i=1:N
    request_temp = randraw('zipf',s,R);
    lamda(i,:) = getRequest(request_temp,M,R,percent);
end
%}
%{
%generate the request type for every node
%they obey the same zipf distribution
%but the popular items are not the same
%for instance in node 1, the most popular item may be requested 1000 times
%and the item here is content 1, but in node 2, all are the same except
%the item here is content 10
%}
request_temp = zipf(s, M, R);
lamda_temp = zeros(1,M);
for i=1:R
    lamda_temp(request_temp(i)) = lamda_temp(request_temp(i)) + 1;
end
lamda1 = sort(lamda_temp, 'descend');
lamda = zeros(N,M);
correlation = 0.5;
lamda(1,:) = lamda1;
for i=2:N
    lamda(i,:) = correlationRequest(lamda1, percent, correlation);
end


%sort the request, descending
%get the most x popular items per node
p = zeros(N,M);
for i=1:N
    [y,p(i,:)] = sort(lamda(i,:), 'descend');
end

dd = zeros(1,c+1);
dd_temp = zeros(3,c+1);
%A_temp represents all the items stored in all nodes, include the same
%ones, in parse one
%Ai represents the items stored in every node in parse one
%A represents all the items stored in all nodes, all are exclusive, in
%parse one

%Bi represents the items stored in every node in parse two
%Ci represents the remaining space in every node, 0 for free, 1 otherwise
%B represents all the items stored in all nodes, both parse one and two

%D represents all the items that are not stored after parse one and two,
%thus these items should be request from the server
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
    
    for k=1:N*(c-x)
        [Bi,Ci] = getCacheNode(Bi,Ci,P,lamda,k);
    end
    
   % Bi = allocateCacheNode(Bi, Ci, P, lamda);
    
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
ratio1 = min(dd)/dd(1,1);
ratio2 = min(dd)/dd(1, c+1);


