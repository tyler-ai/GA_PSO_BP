clear
clc

T = [1790 1800 1810 1820 1830 1840 1850 1860 1870 1880 1890 1900 1910 1920 1930 1940 1950 1960 1970 1980];
N = [323.45 341.6 360.7 381 409 412 412 377 358 368 380 400 423 472 489 518.77 551.67 662.07 825.4 987];

[x,PS_x] = mapminmax(T, 0, 1);
[y,PS_y] = mapminmax(N, 0, 1);

h = 5;%隐含层节点数
l = 0.3;%学习率
max_T = 10000;%最大迭代次数
Error = 0.005;%最小终止误差
w1 = 10*rand(h,1);%输入层—隐含层权值
w2 = 10*rand(1,h);%隐含层—输出层权值
yw1 = 10*rand(h,1);%隐含层阈值
yw2 = 10*rand;%输出层阈值
t = cputime;
 
for i=1:max_T
    e=0;
    for b=1:length(x)
        net1=x(b)*w1-yw1;
        out1=logsig(net1);
        net2=w2*out1-yw2;
        out2(b)=net2;
        det2 =y(b) - out2(b);
        det1 = ((det2 * w2') .* out1) .*(1-out1);
        w1 = w1 + det1 * x(b) * l;
        w2 = w2 + (det2 * out1)' * l;
        yw1 = -det1 * l + yw1;
        yw2 = -det2 * l + yw2;
        ei=(out2(b)-y(b))^2;
        e=ei+e;%累计误差
    end
    Err(i)=e;
    if Err(i)<=Error%终止训练条件
        break;
    end
    fprintf('经%d次训练，误差为%f，用时%fs\n\n',i,Err(i),cputime-t);
end
N2=mapminmax('reverse',out2,PS_y);

%预测样本
year=[1990 2000 2010 2020 2030 2040 2050];
num=[1135.18 1264.10 1314 1500 NaN NaN NaN];
u=mapminmax('apply',year,PS_x);

%生成预测样本输出值
for i=1:length(u)
    test_net1=u(i)*w1-yw1;
    test_out1=logsig(test_net1);
    test_net2=w2*test_out1-yw2;
    test_out2(i)=test_net2;
end
num2=mapminmax('reverse',test_out2,PS_y);

subplot(3,2,[1 2])
%comet(Err)
plot(Err,'r')
title('均方误差迭代曲线')

subplot(323)
plot(T,N,'k-s')
hold on
plot(T,N2,'r*-')
grid on
title('训练样本拟合效果图')
legend('真实值','逼近值')

subplot(324)
plot(year,num,'k-s')
hold on
plot(year,num2,'r*-')
grid on
title('预测样本拟合效果图')
legend('真实值','预测值')

subplot(325)
stem(T,N-N2,'b')
title('训练样本各点误差图')

subplot(326)
stem(year,num-num2,'b')
title('预测样本各点误差图')

figure
plot(T,N,'-*' ,'LineWidth',1.5)
hold on
plot(year,num,'-p' ,'LineWidth',1.5)
plot(T,N2,'-o' ,'LineWidth',1.5)
plot(year,num2,'-s' ,'LineWidth',1.5)
xlabel('年份')
ylabel('人口(*10^6)')
legend('1790-1980实际人口','1990-2020实际人口','BP拟合人口','BP预测人口')


