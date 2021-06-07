 clear
clc
%分岔图
n = 1
for r = 0:0.01:4%自然增长率
    xn = 0.5;%初始种群数量
    for i = 1:200
        xn = r * xn * (1 - xn);
        if i>190
            plot(r,xn,'b.')
            hold on;
        end
        n = n + 1
    end
    pause(0.0000001)%动态显示
end
title('虫口模型分岔图')


