clear
clc
%*********初始化
M=50;  %种群规模
k=5;
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
fmin=inf;
%*******全局最优粒子位置初始化
gb=X;
for i=1:M
    for L=i-k:i+k
        if L<1
            L=L+M;
        elseif L>M
            L=L-M;
        end
        if f(X(L,:))<f(gb(i,:))
            gb(i,:)=X(L,:);
        end
    end
    if f(X(i,:))<fmin
        fmin=f(X(i,:));
        best=X(i,:);
    end
end
%********粒子个体历史最优位置初始化
pb=X;
%********算法迭代
for t=1:Tmax
    t
    w=wmax-(wmax-wmin)*t/Tmax;  %线性下降惯性权重
    for i=1:M
        %******更新粒子速度
        v(i,:)=w*v(i,:)+c1*rand(1)*(pb(i,:)-X(i,:))+c2*rand(1)*(gb(i,:)-X(i,:));
        %******速度约束
        if v(i,1)>v1m; v(i,1)=v1m;end
        if v(i,2)>v2m; v(i,2)=v2m; end
        if v(i,1)<-v1m;v(i,1)=-v1m;end
        if v(i,2)<-v2m;v(i,2)=-v1m;end
        %*******更新粒子位置
        X(i,:)=X(i,:)+v(i,:);
    end
    %更新pbest和gbest
    for i=1:M
        if f(X(i,:))<f(pb(i,:))
            pb(i,:)=X(i,:);
        end
        for L=i-k:i+k
            if L<1
                L=L+M;
            elseif L>M
                L=L-M;
            end
            if f(X(L,:))<f(gb(i,:))
                gb(i,:)=X(L,:);
            end
        end
        if f(gb(i,:))<f(best)
            best=gb(i,:);
        end
    end
    %保存最佳适应度
    re(t)=f(best);
end
best
figure
plot(re,'*-','LineWidth',2)
xlabel('迭代次数')
ylabel('适应度')
re(end)
figure
X=1:15;
Y=[352	211	197	160	142	106	104	60	56	38	36	32	21	19	15];
Y1=best(1)*exp(best(2).*X);
plot(X,Y,'o',X,Y1,':','LineWidth',3);
