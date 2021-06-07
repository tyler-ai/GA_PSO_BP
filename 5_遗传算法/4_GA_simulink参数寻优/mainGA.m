clear
clc
tic
global kp ki kd
N = 30;%初始化种群规模
T = 30;%初始化迭代次数
pc = 0.9;%交叉概率
pm = 0.1;%变异概率
per = 2;%求解精度，小数点后几位
a1 = 0;b1 = 10; %kp范围,（第一维度）
a2 = 0;b2 = 300;%ki范围,（第二维度）
a3 = 0;b3 = 1;  %kd范围,（第三维度）
L1 = ceil(log2((b1 - a1) * 10^per));%计算kp编码长度
L2 = ceil(log2((b2 - a2) * 10^per));%计算ki编码长度
L3 = ceil(log2((b3 - a3) * 10^per));%计算kd编码长度
L = L1 + L2 + L3;%染色体总长度
pop = round(rand(N,L));%初始化种群
maxf = -inf;
for i = 1:N
    x1(i)=bin2dec(num2str(pop(i,1:L1)))*(b1-a1)/(2^L1-1)+a1;%解码kp
    x2(i)=bin2dec(num2str(pop(i,L1+1:L1+L2)))*(b2-a2)/(2^L2-1)+a2;%解码ki
    x3(i)=bin2dec(num2str(pop(i,L1+L2+1:end)))*(b3-a3)/(2^L3-1)+a3;%解码kd
    x(1,:)=[x1(i),x2(i),x3(i)];
    y(i)=f(x(1,:));%计算个体适应度
    if y(i)>maxf
        maxf=y(i);%更新最优
        opmx=x(1,:);
    end
end

for t=1:T
    
    %select
    p=y/sum(y);%轮盘赌选择
    q=cumsum(p);
    for i=1:N
        temp=rand(1);
        Ind=find(q>=temp);%查找指向个体索引
        s2(i,:)=pop(Ind(1),:);
    end
    %crossover
    for i=1:N
        if rand(1)<pc%交叉判断
            I=randi([1,N]);
            J=randi([1,N]);
            if I~=J
                k1=randi([1,L]);
                k2=randi([1,L]);
                if k1>k2 || k1==k2%单点交叉
                    temp = s2(I,k1+1:end);
                    s2(I,k1+1:end)= s2(J,k1+1:end);
                    s2(J,k1+1:end)= temp;
                else%双点交叉
                    temp = s2(I,k1+1:k2);
                    s2(I,k1+1:k2)= s2(J,k1+1:k2);
                    s2(J,k1+1:k2)= temp;
                end
            end
        end
    end
    %mututation
    for i=1:N
        if rand(1)<pm%变异判断
            I=1+fix((N-1)*rand(1));%变异个体
            k=1+fix((L-1)*rand(1));%变异位置
            s2(I,k)=1-s2(I,k);%变异
        end
    end
    %更新种群
    pop=s2;
    for i=1:N
        x1(i)=bin2dec(num2str(pop(i,1:L1)))*(b1-a1)/(2^L1-1)+a1;%解码kp
        x2(i)=bin2dec(num2str(pop(i,L1+1:L1+L2)))*(b2-a2)/(2^L2-1)+a2;%解码ki
        x3(i)=bin2dec(num2str(pop(i,L1+L2+1:end)))*(b3-a3)/(2^L3-1)+a3;%解码kd
        x(1,:)=[x1(i),x2(i),x3(i)];
        y(i)=f(x(1,:));%计算适应度
        if y(i)>maxf
            maxf=y(i);
            opmx=x(1,:);
        end
    end
    max_f(t)=maxf;%保存最优适应度
    mean_f(t)=mean(y);%保存种群平均适应度
    fprintf('经%d代，最优适应度值为：%f\n\n',t,maxf)
end

figure
plot(1:T,max_f,'b',1:T,mean_f,'g','LineWidth',2)
legend('种群最优适应度值迭代曲线','种群平均适应度值迭代曲线','Location','southeast')
xlabel('迭代次数')
ylabel('适应度值')
maxf
opm_kp = opmx(1)
opm_ki = opmx(2)
opm_kd = opmx(3)
sim_time = 5;
sim_step = 1000;
%生成时间戳
for i=1:sim_step
    time_stamp(i,1) = i * sim_time / sim_step;
end
%生成序列
kp = [time_stamp,ones(sim_step,1)*opm_kp];
ki = [time_stamp,ones(sim_step,1)*opm_ki];
kd = [time_stamp,ones(sim_step,1)*opm_kd];

sim('pid3.slx',[0,5]);
figure
plot(Data_out.Time,Data_out.Data,'LineWidth',2);%绘制寻优仿真曲线
hold on

kp = [time_stamp,ones(sim_step,1)*1];
ki = [time_stamp,ones(sim_step,1)*150];
kd = [time_stamp,ones(sim_step,1)*0.001];
sim('pid3.slx',[0,5]);
plot(Data_out.Time,Data_out.Data,'LineWidth',2);%绘制设定仿真曲线
legend('寻优参数 opmx','设定参数 [1 150 0.001]')
toc