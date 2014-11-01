function [B,C] = getCacheNode(B,C,P,lamda,k)
%in parse two, choose a node among the nodes to store item P(k)
%B, the items stored in every node at present
%C, the remaining space in every node at present
%P, the items sorted by descending of all the items except those stored
%during parse one
%lamda, the request rate at every node
%k, currently process index in P
%B,C, return B and C after cache P(k)

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
        if lamda(i,P(k)) > max
            max = lamda(i,P(k));
            cachenode = i;
        end
    end
end

for i=1:size(B,2)
    if B(cachenode,i) == 0
        break;
    end
end
B(cachenode,i) = P(k);
C(cachenode,i) = 1;