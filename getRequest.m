function lamdai = getRequest(request_temp,M,R,percent)
%given the request type, return the request rate in node i
%request_temp, the origin zipf distribution, while the lower the id, the
%more popular the item is
%M, the number of contents
%R, the total request in node i
%percent, 
%lamdai, return the request rate at node i
lamda_temp = zeros(1,M);
for i=1:R
    lamda_temp(request_temp(i)) = lamda_temp(request_temp(i)) + 1;
end
lamdai = zeros(1,M);
temp = randperm(M*(1-percent)) + M*percent;
for j=1:M
    if j <= M * percent
        lamdai(j) = lamda_temp(j);
    else
        lamdai(j) = lamda_temp(temp(j - M*percent));
    end
end