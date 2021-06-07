clear
clc
tic
N=30;%种群规模
T=100;%迭代次数
pc=0.88;%交叉概率
pm=0.1;%变异概率
dim = 4;%求解变量数
X=10*rand(N,dim)-5;%初始化种群
maxf=-inf;%初始化最优适应度值
for i=1:N%计算适应度值
    y(i)=f(X(i,:));%计算每个个体适应度值
    if y(i)>maxf %判断每个个体是否优于最优个体
        maxf=y(i);%更新最优适应度值
        opmx=X(i,:);%更新最优个体
    end
end
for t=1:T%开始迭代
    t
    %轮盘赌选择
    p=(y+50)/sum(y+50);%得到每个个体在种群适应度之和中的占比
    q=cumsum(p);%累计占比适应度
    for i=1:N
        temp=rand(1);%生成最近数
        Ind=find(q>=temp);%得到选择个体的索引
        X2(i,:)=X(Ind(1),:);%为新种群赋值
    end
    %交叉
    for i=1:N
        if rand(1)<pc%判断是否交叉
            I=randi([1,N]);%得到交叉个体1
            J=randi([1,N]);%得到交叉个体2
            while I==J%两个体是否为同一个
                I=randi([1,N]);
                J=randi([1,N]);
            end
            k=randi([1,dim]);%得到交叉节点
            temp = X2(I,k+1:end);%替换交叉
            X2(I,k+1:end)= X2(J,k+1:end);
            X2(J,k+1:end)= temp;
        end
    end
    %变异
    Mu = rand(N,dim);%变异概率
    X2 = (Mu>=pm).*X2 + (Mu<pm).*Mu;%概率大于变异概率不变，小于则替换
    %更新
    X=X2;
    for i=1:N
        y(i)=f(X(i,:));%计算每个个体适应度值
        if y(i)>maxf%判断每个个体是否优于最优个体
            maxf=y(i);%更新最优适应度值
            opmx=X(i,:);%更新最优个体
        end
    end
    max_f(t)=maxf;%记录每一代最优
    mean_f(t)=mean(y);%记录每一代种群适应度均值
end
%绘制并打印结果
plot(1:T,max_f,1:T,mean_f,'LineWidth',2)
legend('最优适应度值','种群平均适应度值','Location','SouthEast')
xlabel('迭代次数')
ylabel('适应度值')
opmx
maxf
toc%打印用时