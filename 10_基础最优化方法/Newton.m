clear
clc
%求y = 2 * x.^2 + 4 * x-30在[-10,10]内所有解
x = -20:0.5:20;
y = 2*x.^2 + 4*x-30;
plot(x,y,'LineWidth',2)
hold on
plot(x,zeros(size(y)),'LineWidth',2)

for x0 = -20:1:20
    x_chu = x0;
    y0 = 2 * x0.^2 + 4 * x0 - 30;
    while abs(y0) > 0.001
        df = 4 * x0 + 4;
        if df == 0
            break;
        end
        x1 = x0 - y0 / df;
        plot([x0,x0,x1],[0,y0,0],'r')
        x0 = x1;
        y0 = 2 * x0.^2 + 4 * x0 - 30;
        pause(0.02)
    end
    if df == 0
        fprintf('初始迭代点为：%f,无解\n\n',x_chu);
    else
        fprintf('初始迭代点为：%f,解为:%f\n\n',x_chu,x0);
    end
end
title('牛顿迭代法求y = 2 * x.^2 + 4 * x-30在[-10,10]内所有解')