clear
clc
T=[1790 1800 1810 1820 1830 1840 1850 1860 1870 1880 1890 1900 1910 1920 1930 1940 1950 1960 1970 1980];
N=[3.9 5.3 7.2 9.6 12.9 17.1 23.2 31.4 38.6 50.2 62.9 76.0 92.0 106.5 123.2 131.7 150.7 179.3 204.0 226.5];
y=log(N);
t=T-T(1);
a=polyfit(t,y,1);
r=a(1)
N0=exp(a(2))
N_M=N0.*exp(r*(t));

year=[1990 2000 2010 2020];
num=[248.7 281.4 310.2 326.8];
p_N=N0.*exp(r*(year-T(1)));

figure
plot(T,N,'-*' ,'LineWidth',1.5)
hold on
plot(year,num,'-p' ,'LineWidth',1.5)
plot(T,N_M,'-o' ,'LineWidth',1.5)
plot(year,p_N,'-s' ,'LineWidth',1.5)
xlabel('年份')
ylabel('人口(*10^6)')
legend('1790-1980美国实际人口','1990-2020美国实际人口','Malthus拟合人口','Malthus预测人口')
