%不动点迭代法求发f(x) = 0.3*x*cos(x)-x+3在[1,5]的根
clear
clc
x = 1:0.1:5;
y = 0.3 * x.*cos(x) + 3;
plot(x,y,'LineWidth',2)
hold on
plot(x,x,'LineWidth',2)
for x0 =1:0.5:5
    x_chu = x0;%初始迭代点
    y0 = 0.3 * x0.*cos(x0) + 3;
    while abs(y0-x0)>0.001
        x1 = 0.3 * x0.*cos(x0) + 3;
        plot([x0,x0,x1],[x0,x1,x1],'r')
        y0 = x0;
        x0 = x1;
        pause(0.01)
    end
    fprintf('初始迭代点为：%f，解为:%f\n\n',x_chu,x0);
end
title('不动点迭代法求发f(x) = 0.3 * x * cos(x) - x + 3的根')