clear all;

global c;
global p;
global lamda;
global N;
global tl;
global tr;
global ts;
global M;

%this is the main simulation loop
N = 10;     %number of nodes
c = 20;     %cache size per node
M = 1000;   %number of contents
R = 100000;  %requests per node
%s = [0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55];    %s para in the zipf distribution per node
%s = 2;

tl = 1;     %time delay when request a item that locally valiable
tr = 30;    %time delay when request a item that group cache are valiable
ts = 63;   %time delay when request a item that only server has

percent = 0;     %amout of same popular items among all the nodes

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

var_delay = zeros(1, 4);
pop_delay = zeros(1, 4);
delta = zeros(1, 4);
row = 1;

for s=0.5:0.3:1.4
    col = 1;
    request_temp = zipf(s, M, R);
    lamda_temp = zeros(1,M);
    for i=1:R
        lamda_temp(request_temp(i)) = lamda_temp(request_temp(i)) + 1;
    end
    lamda1 = sort(lamda_temp, 'descend');
    lamda = zeros(N,M);
    %correlation = 0.8;
    for correlation=0.2:0.2:0.8
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
        %var_delay(index) = varAllocate();
        %pop_delay(index) = popAllocate();
        var_delay(col) = varAllocate();
        pop_delay(col) = popAllocate();
        delta(row, col) = (pop_delay(col) - var_delay(col))/pop_delay(col) * 1000;
        col = col + 1;
    end
    row = row + 1;
end