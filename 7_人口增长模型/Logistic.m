clear
clc
T=[1790 1800 1810 1820 1830 1840 1850 1860 1870 1880 1890 1900 1910 1920 1930 1940 1950 1960 1970 1980];
N=[3.9 5.3 7.2 9.6 12.9 17.1 23.2 31.4 38.6 50.2 62.9 76.0 92.0 106.5 123.2 131.7 150.7 179.3 204.0 226.5];
a=[5,1];%初值
t=T-T(1);
f=@(a,t)a(1)./(1+((a(1)./N(1)-1)*exp(-a(2)*t)));

[A,resnorm]=lsqcurvefit(f,a,t,N) %resnorm残差平方和  A是参数
N_L=f(A,t);

year=[1990 2000 2010 2020];
t=year-T(1);
num=[248.7 281.4 310.2 326.8];
p_N=f(A,t);

figure
plot(T,N,'-*' ,'LineWidth',1.5)
hold on
plot(year,num,'-p' ,'LineWidth',1.5)
plot(T,N_L,'-o' ,'LineWidth',1.5)
plot(year,p_N,'-s' ,'LineWidth',1.5)
xlabel('年份')
ylabel('人口(*10^6)')
legend('1790-1980美国实际人口','1990-2020美国实际人口','Logistic拟合人口','Logistic预测人口')
