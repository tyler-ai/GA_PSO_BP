clear
clc
%*********初始化
M = 100;  %种群规模
%初始化粒子位置
X = rand(M,2);;
c1 = 2;  %学习因子
c2 = 2;
wmax = 0.9;%最大最小惯性权重
wmin = 0.4;
Tmax = 50;%迭代次数
v = zeros(M,2);%初始化速度
%*******全局最优粒子位置初始化
fmin=inf;
for i=1:M
    fx = f(X(i,:));
    if fx<fmin
        fmin=fx;
        gb=X(i,:);
    end
end
%********粒子个体历史最优位置初始化
pb=X;
%********算法迭代
for t=1:Tmax
    t
    w(t)=wmax-(wmax-wmin)*t/Tmax;  %线性下降惯性权重
    for i=1:M
        %******更新粒子速度
        v(i,:)=w(t)*v(i,:)+c1*rand(1)*(pb(i,:)-X(i,:))+c2*rand(1)*(gb-X(i,:));

        %*******更新粒子位置
        X(i,:)=X(i,:)+v(i,:);
    end
    %更新pbest和gbest
    for i=1:M
        if f(X(i,:))<f(pb(i,:))
            pb(i,:)=X(i,:);
        end
        if f(X(i,:))<f(gb)
            gb=X(i,:);
        end
    end
    %保存最佳适应度
    re(t)=f(gb);
end
figure
plot(re,'-*','LineWidth',2)
xlabel('迭代次数')
ylabel('适应度')
gb
re(end)
figure
X=1:15;
Y=[352	211	197	160	142	106	104	60	56	38	36	32	21	19	15];
Y1=gb(1)*exp(gb(2).*X);
plot(X,Y,'o',X,Y1,':','LineWidth',2);
