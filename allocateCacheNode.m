function B = allocateCacheNode(B, C, P, lamda)

allocateItemsSize = size(C,1) * size(C,2);
allocateItems = P(1:allocateItemsSize);
lamdaVar = zeros(1,allocateItemsSize);
temp = zeros(1,size(C,1));
for i=1:allocateItemsSize
    for j=1:size(C,1)
        temp(j) = lamda(j, P(i));
    end
    lamdaVar(i) = var(temp);
end

[~, sortedIndex] = sort(lamdaVar, 'descend');


for k=1:allocateItemsSize
    item = allocateItems(sortedIndex(k));    %Items to allocate at ith iteration
    index = zeros(1,size(B,1));
    for i=1:size(B,1)
        if sum(C(i,:)) < size(B,2)
            index(i) = 1;
        end
    end
    
    max = -1;
    cachenode = 0;
    for i=1:size(B,1)
        if index(i) == 1
            if lamda(i,item) > max
                max = lamda(i,item);
                cachenode = i;
            end
        end
    end
    
    for i=1:size(B,2)
        if B(cachenode,i) == 0
            break;
        end
    end
    B(cachenode,i) = item;
    C(cachenode,i) = 1;
end