clear
clc
yn = 0.2;%��ʼ��Ⱥ����
r = 2;%��Ȼ������
x = 0:0.001:1;
y = r .* x .* (1 - x);%���ģ��
plot(x,y ,'LineWidth',1.5)
hold on
grid on
plot(x,x ,'LineWidth',1.5)
n = 0;
last_n = inf;
current_n = -inf;
while (abs(last_n - current_n))> 0.00000000000001
    n = n + 1
    xn = yn;
    last_n = xn;
    yn = r * xn * (1 - xn);
    current_n = yn;
    plot([xn,xn,yn],[xn,yn,yn],'r' ,'LineWidth',1.5)
    pause(0.1)
end
title('�����������ͼ')