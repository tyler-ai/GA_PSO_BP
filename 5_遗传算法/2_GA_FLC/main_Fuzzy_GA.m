clear
clc

% 初始化模糊控制系统参数
global num
global den
global Samping_time
global Sys_time
global kp
global ki
global kd
global Expected_Value

Samping_time=0.3;%采样时间
kp=0.2;
ki=0.002;
kd=10;%PID参数
Sys_time=100;%系统运行次数

Expected_Value=3.194;%系统期望值

num=1;%系统参数
den=conv(conv([1,0.1],[1,0.2]),[1,0.7]);
G=tf(num,den);
Z=c2d(G,Samping_time,'zoh');%离散化
[num,den]=tfdata(Z,'v');
linguistic_values_num=3;%语言值数量

% 初始化遗传算法参数
N=30;%种群数量
T_max=30;%最大迭代次数
pc=0.8;%交叉概率
pm=0.1;%变异概率
L=linguistic_values_num^2+linguistic_values_num*2;%码长
Rule_Table=randi([1,linguistic_values_num],[N,linguistic_values_num^2]); %模糊规则表
Membership_Function_Positive=rand(N,linguistic_values_num); %隶属度函数正的部分
Membership_Function_Negative=-1*rand(N,linguistic_values_num); %隶属度函数负的部分
rule_table=zeros(1,linguistic_values_num^2);
membership_function_positive=zeros(1,linguistic_values_num);
membership_function_negative=zeros(1,linguistic_values_num);
S=[Rule_Table,Membership_Function_Positive,Membership_Function_Negative];%初始化种群
Max_f=0;%目标函数最大值

% 第一次选择
for i=1:N
    rule_table(i,:)=S(i,1:linguistic_values_num^2);
    membership_function_positive(i,:)=S(i,linguistic_values_num^2+1:linguistic_values_num^2+3);
    membership_function_negative(i,:)=S(i,linguistic_values_num^2+4:end);
    fprintf('第1次选择，计算第%d个个体适应度中......',i);
    Fitness(i)=Object_Function(rule_table(i,:),membership_function_positive(i,:),membership_function_negative(i,:));
    fprintf('适应度值为：%f\n',Fitness(i));
    if Fitness(i)>Max_f
        Max_f=Fitness(i);
        opm_rule_table=rule_table(i,:);
        opm_membership_function_positive=membership_function_positive(i,:);
        opm_membership_function_negative=membership_function_negative(i,:);
    end
end

% 开始迭代
t=cputime;
for T=1:T_max
    % 选择
    p=Fitness/sum(Fitness);
    q=cumsum(p);
    for i=1:N
        temp=rand(1);
        Ind=find(q>=temp);
        S2(i,:)=S(Ind(1),:);
    end
    % 交叉
    for i=1:N
        if rand(1)<pc
            I=randi([1,N]);
            J=randi([1,N]);
            if I~=J
                k1=randi([1,L]);
                k2=randi([1,L]);
                if k1>k2 || k1==k2%单点交叉
                    temp = S2(I,k1+1:end);
                    S2(I,k1+1:end)= S2(J,k1+1:end);
                    S2(J,k1+1:end)= temp;
                else%双点交叉
                    temp = S2(I,k1+1:k2);
                    S2(I,k1+1:k2)= S2(J,k1+1:k2);
                    S2(J,k1+1:k2)= temp;
                end
            end
        end
    end
    % 变异
    for i=1:N
        if rand(1)<pm
            I=randi([1,N]);
            k1=randi([1,linguistic_values_num^2]);
            k2=randi([linguistic_values_num^2+1,linguistic_values_num^2+3]);
            k3=randi([linguistic_values_num^2+4,linguistic_values_num^2+6]);
            S2(I,k1)=randi([1,linguistic_values_num]);
            S2(I,k2)=rand();
            S2(I,k3)=-rand();
        end
    end
    
    % 复制
    S=S2;
    for i=1:N
        rule_table(i,:)=S(i,1:linguistic_values_num^2);
        membership_function_positive(i,:)=S(i,linguistic_values_num^2+1:linguistic_values_num^2+3);
        membership_function_negative(i,:)=S(i,linguistic_values_num^2+4:end);
        fprintf('计算第%d代第%d个个体适应度中......',T,i);
        Fitness(i)=Object_Function(rule_table(i,:),membership_function_positive(i,:),membership_function_negative(i,:));
        fprintf('适应度值为：%f\n',Fitness(i));
        if Fitness(i)>Max_f
            Max_f=Fitness(i);%最大适应度
            opm_rule_table=rule_table(i,:);%最佳模糊控制表
            opm_membership_function_positive=membership_function_positive(i,:);%最佳ap,bp,cp
            opm_membership_function_negative=membership_function_negative(i,:);%最佳an,bn,cn
        end
    end
    
    max_f(T)=Max_f;%最大适应度
    mean_f(T)=mean(Fitness);%种群平均适应度
    
    y=zeros(1,Sys_time);
    u=zeros(1,Sys_time);
    er=zeros(1,Sys_time);
    yr=zeros(1,Sys_time);
    e1=0;e2=0;E1=0;
    y1=0;y2=0;y3=0;
    u1=0;u2=0;u3=0;
    e=zeros(1,Sys_time);
    E=zeros(1,Sys_time);
    for j =1:Sys_time
        time(j)=j*Samping_time;%时间参数
        r(j)=Expected_Value;%期望值
        y(j)=-den(2)*y1-den(3)*y2-den(4)*y3+num(2)*u1+num(3)*u2+num(4)*u3;
        e(j)=r(j)-y(j);
        er(j)=(e(j)-e1)/Samping_time;
        y3=y2;y2=y1;y1=y(j);
        u3=u2;u2=u1;
        Delta_e=Fuzzy_Rule(opm_rule_table,opm_membership_function_positive,opm_membership_function_negative,e(j),er(j));
        E(j)=e(j)+Delta_e;
        u(j)=kp*E(j)+ki*sum(E)+kd*(E(j)-E1);
        E1=E(j);
        u1=u(j);
        e2=e1;e1=e(j);
    end
    plot(time,y,'LineWidth',2)
    hold on
    pause(0.01)
    each_time=cputime-t;
    fprintf('第%d代，最大适应度值为%d，种群平均适应度值为%d，用时%ds.\n',T,fix(Max_f),fix(mean_f(T)),round(each_time));
end
title('各代最优阶跃响应曲线')

figure
plot(1:T,max_f,'b',1:T,mean_f,'g')
legend('种群最大适应度值','种群平均适应度值')
xlabel('迭代次数')
ylabel('适应度值')
opm_rule_table
opm_membership_function_positive
opm_membership_function_negative
