clear
clc

% 定义训练样本
% P 为输入矢量 T 为目标矢量
num = [0;0;0;0;0;0;0;0;0;0;0;0;6;6;5;20;16;15;31;79;110;103;119;123;55;262;455;720;393;244;950;895;1823;3775;4008;5357;7123;14961;11947;11238;17511;18313;20400;18353;20550;26245;19543;29251;20871;34676;31156;30784;30710;36082;33649;37455;30881;26163;25101;20502;39789;20181;30593;41672;21055;14191;27434;36863;17165;28436;34567;34200;33734;35097;47237;33433;34009;32693;27901;24856;25108;23051;31697;30635;23117;23153;16141;21280;6259;20018;22939;24284;25697;46807;21293;20923;28223;25401;21785;18842;20820;18909;17353;19991;25076;24278;25895;22153;14966]';
time = 1:length(num);
%归一化
[train_num,PS_num] = mapminmax(num, 0, 1); 
[train_time,PS_time] = mapminmax(time, 0, 1); 

% 创建一个新的前向神经网络
net=newff(minmax(train_time),minmax(train_num),[9,7,3],{'logsig'},'traingdm');

% 设置训练参数
net.trainParam.show = 10;
net.trainParam.lr = 0.05;
net.trainParam.mc = 0.01;
net.trainParam.epochs = 10000;
net.trainParam.goal = 1e-10;
net.trainParam.min_grad = 1e-10;

% 训练 BP 网络
[net,tr]=train(net,train_time,train_num);

% 对 BP 网络进行仿真
sim_train_num = sim(net,train_time);
sim_reverse_train_num=mapminmax('reverse',sim_train_num,PS_num);
% 计算仿真误差
E_train = num - sim_reverse_train_num;
MSE=mse(E_train);


%预测样本
le=length(train_num);
test_time=[le+1 le+2 le+3 le+4 le+5];
test_num=[22030 23256 30051 34889 21010];
u = mapminmax(test_time, 0, 1); %归一化

sim_test_num = sim(net,u);
sim_reverse_test_num = mapminmax('reverse',sim_test_num,PS_num);%反归一化
% 计算仿真误差
E_test = test_num - sim_reverse_test_num;
MSE=mse(E_test);

%绘图
subplot(211)
plot(time,num,'o:','LineWidth',1.5)
hold on
plot(time,sim_reverse_train_num,'*-','LineWidth',1.5)

plot(test_time,test_num,'-o' ,'LineWidth',1.5)
plot(test_time,sim_reverse_test_num,'-s' ,'LineWidth',1.5)
grid on
xlabel('年份')
ylabel('人口(*10^6)')
legend('训练实际新增','测试实际新增','BP拟合新增','BP预测新增')

subplot(212)
stem(time,E_train,'LineWidth',1.5)
hold on
stem(test_time,E_test,'LineWidth',1.5)
title('误 差 图')

% fprintf('输入到隐层权值')
% w1=net.iw{1,1}
% fprintf('隐层阈值')
% theta1=net.b{1}
% fprintf('隐层到输出层权值')
% w2=net.lw{2,1}
% fprintf('输出层阈值')
% theta2=net.b{2}