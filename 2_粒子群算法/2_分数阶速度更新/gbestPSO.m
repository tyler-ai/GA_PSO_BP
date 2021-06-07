clear
clc
%*********初始化
M=100;  %种群规模
%初始化粒子位置
x1=rand(M,1);
x2=rand(M,1);
%x3=rand(M,1);
%X=[x1,x2,x3]
X=[x1,x2];
c1=2;  %学习因子
c2=2;
wmax=0.9;%最大最小惯性权重
wmin=0.4;
Tmax=50;%迭代次数
%v=zeros(M,3);
v=zeros(M,2);%初始化速度
v1m=50;  %速度1约束
v2m=1;%速度2约束
alph = 0.5;  
vt_1 = v;
vt_2 = v;
vt_3 = v;
%*******全局最优粒子位置初始化
fmin=1000;
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
        v(i,:)=alph*v(i,:)+...
            1/2*alph*(1-alph)*vt_1(i,:)+...
            1/6*alph*(1-alph)*(2-alph)*vt_2(i,:)+...
            1/24*alph*(1-alph)*(2-alph)*(3-alph)*vt_3(i,:)+...
            c1*rand*(pb(i,:)-X(i,:))+c2*rand*(gb-X(i,:));
        vt_3(i,:) = vt_2(i,:);%迭代更新v(t-3)
        vt_2(i,:) = vt_1(i,:);%迭代更新v(t-2)
        vt_1(i,:) = v(i,:);%迭代更新v(t-1)
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
% X=[1,3,4,5,6,7,8,9,10];
% Y=[10,5,4,2,1,1,2,3,4];
% Y1=gb(1)*X.^2+gb(2)*X+gb(3);
X=1:15;
Y=[352	211	197	160	142	106	104	60	56	38	36	32	21	19	15];
Y1=gb(1)*exp(gb(2).*X);
plot(X,Y,'o',X,Y1,':','LineWidth',2);
