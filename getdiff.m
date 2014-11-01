function result=getdiff(setA,setB)
%get those items in setA but not in setB

temp = setdiff(setA,setB);
result = zeros(1,size(temp,2));

k = 1;
for i=1:size(setA,2)
    flag = 0;
    for j=1:size(setB,2)
        if setA(i) == setB(j)
            flag = 1;
            break;
        end
    end
    if flag == 0
        result(k) = setA(i);
        k = k + 1;
    end
end