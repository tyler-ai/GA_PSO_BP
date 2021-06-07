clear
clc
close all
load('CityPosition3.mat');%导入城市坐标位置,可以换成load CityPosition1~3.mat
NIND=100;       %种群大小
MAXGEN=300;     %迭代次数
Pc=0.9;         %交叉概率
Pm=0.1;         %变异概率
GGAP=0.9;       %代沟(Generation gap)
D=Distanse(X);  %生成距离矩阵
N=size(D,1);    %(34*34)
%% 初始化种群
Chrom=InitPop(NIND,N);
% 在二维图上画出所有坐标点
figure
plot(X(:,1),X(:,2),'o');
%% 画出随机解的路线图
figure
DrawPath(Chrom(1,:),X)
%% 输出随机解的路线和总距离
disp('初始种群中的一个随机值:')
OutputPath(Chrom(1,:));
Rlength=PathLength(D,Chrom(1,:));
disp(['总距离：',num2str(Rlength)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
%% 优化
gen=1;
ObjV=PathLength(D,Chrom);  %计算路线长度
preObjV=min(ObjV);
while gen<MAXGEN
    %% 计算适应度
    ObjV=PathLength(D,Chrom);  %计算路线长度
    preObjV(gen)=min(ObjV);
    fprintf('经%d代，最优路径长度为：%1.10f\n',gen,preObjV(gen))
    FitnV=Fitness(ObjV);
    SelCh=Select(Chrom,FitnV,GGAP);% 选择
    SelCh=Recombin(SelCh,Pc);% 交叉操作
    SelCh=Mutate(SelCh,Pm);% 变异
    SelCh=Reverse(SelCh,D);% 逆转操作
    Chrom=Reins(Chrom,SelCh,ObjV);% 重插入子代的新种群
    gen=gen+1; % 更新迭代次数
end

%% 画出最优解的路线图
figure
ObjV=PathLength(D,Chrom);  %计算路线长度
[minObjV,minInd]=min(ObjV);
DrawPath(Chrom(minInd(1),:),X)
%% 画出迭代曲线
figure
plot(preObjV)
title('优化过程')
xlabel('代数')
ylabel('最优值')
%% 输出最优解的路线和总距离
disp('最优解:')
p=OutputPath(Chrom(minInd(1),:));
disp(['总距离：',num2str(ObjV(minInd(1)))]);
disp('-------------------------------------------------------------')
