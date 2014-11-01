function lamdai=correlationRequest(lamda1, percent, correlation)
%given the request type, return the request rate in node i
%lamda1,the request type at node  1
%percent, 
%correlation, 
%lamdai, return the request rate at node i

start = size(lamda1,2) * percent;
lamdai = zeros(size(lamda1));

for i=1:start
    lamdai(i) = lamda1(i);
end

for i=(start+1):size(lamda1,2)
    k = randi([start+1, min(ceil(correlation*size(lamda1,2))+i+start,size(lamda1,2))]);
    while lamdai(k) ~= 0
        k = randi([start+1, min(ceil(correlation*size(lamda1,2))+i+start,size(lamda1,2))]);
    end
    lamdai(k) = lamda1(i);
end
