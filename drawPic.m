data = [1.31,2.14,2.74,3.06];
x = [0.2,0.4,0.6,0.8];
plot(x, data, 'b--o');
title('按方差放置与按流行度放置对比');
xlabel('节点请求随机化参数\rho');
ylabel('比值\theta');