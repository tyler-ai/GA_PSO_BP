clear
clc
tic
global B v
B = [0.6013 -0.6013 -2.2849 -1.9574 1.9574 2.2849 1.4871;
    0.8266 0.8266 -0.4628 -0.8017 -0.8107 0.468 0.0024;
    -0.2615 0.2615 -0.0944 -0.1861 0.1861 0.0944 -0.8823];
v = [2;5;10];
per = 2;%求解精度，小数点后几位

N = 500;%种群规模
T = 100;%迭代次数
pc = 0.9;%交叉概率
pm = 0.2;%变异概率

u1 = -55;d1 = 25;%x1范围
u2 = -55;d2 = 25;%x2范围
u3 = -30;d3 = 30;%x3范围
u4 = -30;d4 = 30;%x4范围
u5 = -30;d5 = 30;%x5范围
u6 = -30;d6 = 30;%x6范围
u7 = -30;d7 = 30;%x7范围

L1 = ceil(log2((d1 - u1) * 10^per));%计算x1编码长度
L2 = ceil(log2((d2 - u2) * 10^per));%计算x2编码长度
L3 = ceil(log2((d3 - u3) * 10^per));%计算x3编码长度
L4 = ceil(log2((d4 - u4) * 10^per));%计算x4编码长度
L5 = ceil(log2((d5 - u5) * 10^per));%计算x5编码长度
L6 = ceil(log2((d6 - u6) * 10^per));%计算x6编码长度
L7 = ceil(log2((d7 - u7) * 10^per));%计算x7编码长度

L = L1 + L2 + L3 + L4 + L5 + L6 + L7;%染色体总长度
pop = round(rand(N,L));%初始化种群
minf = inf;
for i = 1:N
    x1(i)=bin2dec(num2str(pop(i,1:L1)))*(d1-u1)/(2^L1-1)+u1;%解码x1
    x2(i)=bin2dec(num2str(pop(i,L1+1:L1+L2)))*(d2-u2)/(2^L2-1)+u2;%解码x2
    x3(i)=bin2dec(num2str(pop(i,L1+L2+1:L1+L2+L3)))*(d3-u3)/(2^L3-1)+u3;%解码x3
    x4(i)=bin2dec(num2str(pop(i,L1+L2+L3+1:L1+L2+L3+L4)))*(d4-u4)/(2^L4-1)+u4;%解码x4
    x5(i)=bin2dec(num2str(pop(i,L1+L2+L3+L4+1:L1+L2+L3+L4+L5)))*(d5-u5)/(2^L5-1)+u5;%解码x5
    x6(i)=bin2dec(num2str(pop(i,L1+L2+L3+L4+L5+1:L1+L2+L3+L4+L5+L6)))*(d6-u6)/(2^L6-1)+u6;%解码x6
    x7(i)=bin2dec(num2str(pop(i,L1+L2+L3+L4+L5+L6+1:L1+L2+L3+L4+L5+L6+L7)))*(d7-u7)/(2^L7-1)+u7;%解码x7
    
    x(i,:)=[x1(i),x2(i),x3(i),x4(i),x5(i),x6(i),x7(i)];
    y(i)=f(x(i,:));%计算个体适应度
    if y(i) < minf
        minf=y(i);%更新最优
        opmx=x(i,:);
    end
end
for t=1:T
    t
    %select
    abs_y = abs(min(y))+10;
    p=(1./(y+abs_y))/sum(1./(y+abs_y));%轮盘赌选择
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
    for i = 1:N
        x1(i)=bin2dec(num2str(pop(i,1:L1)))*(d1-u1)/(2^L1-1)+u1;%解码x1
        x2(i)=bin2dec(num2str(pop(i,L1+1:L1+L2)))*(d2-u2)/(2^L2-1)+u2;%解码x2
        x3(i)=bin2dec(num2str(pop(i,L1+L2+1:L1+L2+L3)))*(d3-u3)/(2^L3-1)+u3;%解码x3
        x4(i)=bin2dec(num2str(pop(i,L1+L2+L3+1:L1+L2+L3+L4)))*(d4-u4)/(2^L4-1)+u4;%解码x4
        x5(i)=bin2dec(num2str(pop(i,L1+L2+L3+L4+1:L1+L2+L3+L4+L5)))*(d5-u5)/(2^L5-1)+u5;%解码x5
        x6(i)=bin2dec(num2str(pop(i,L1+L2+L3+L4+L5+1:L1+L2+L3+L4+L5+L6)))*(d6-u6)/(2^L6-1)+u6;%解码x6
        x7(i)=bin2dec(num2str(pop(i,L1+L2+L3+L4+L5+L6+1:L1+L2+L3+L4+L5+L6+L7)))*(d7-u7)/(2^L7-1)+u7;%解码x7
        
        x(i,:)=[x1(i),x2(i),x3(i),x4(i),x5(i),x6(i),x7(i)];
        y(i)=f(x(i,:));%计算个体适应度
        if y(i) < minf
            minf=y(i);%更新最优
            opmx=x(i,:);
        end
    end
    min_f(t)=minf;%保存最优适应度
end

figure
plot(1:T,min_f,'b','LineWidth',2)
xlabel('迭代次数')
ylabel('适应度值')
fprintf('优化目标 J 值为：\n\t%f, \nu 值为：\n\t%f\n\t%f\n\t%f\n\t%f\n\t%f\n\t%f\n\t%f\n',minf,opmx)

toc