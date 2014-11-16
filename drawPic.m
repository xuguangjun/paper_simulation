data(1,:) = [0.2818,0.6752, 0.7980,1.0052];
data(2, :) = [0.8236, 0.9633, 0.9731, 1.7265];
data(3, :) = [1.8457, 2.8816, 3.3995, 3.5799];
data(4, :) = [2.7180, 3.7298, 3.8232, 5.0176];
x = [0.2,0.4,0.6,0.8];
plot(x, data(1,:), 'b--o');
hold on;
plot(x, data(2,:), 'r--x');
hold on;
plot(x, data(3,:), 'k--+');
hold on;
plot(x, data(4,:), 'g--*');
title('按方差放置与按流行度放置对比');
xlabel('节点请求随机化参数\rho');
ylabel('比值\theta');
legend('s=0.5', 's=0.8', 's=1.1', 's=1.4');