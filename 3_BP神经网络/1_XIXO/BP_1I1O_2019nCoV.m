clear;
clc;
tic;

% 导入训练数据


num = [0;0;0;0;0;0;0;0;0;0;0;0;6;6;5;20;16;15;31;79;110;103;119;123;55;262;455;720;393;244;950;895;1823;3775;4008;5357;7123;14961;11947;11238;17511;18313;20400;18353;20550;26245;19543;29251;20871;34676;31156;30784;30710;36082;33649;37455;30881;26163;25101;20502;39789;20181;30593;41672;21055;14191;27434;36863;17165;28436;34567;34200;33734;35097;47237;33433;34009;32693;27901;24856;25108;23051;31697;30635;23117;23153;16141;21280;6259;20018;22939;24284;25697;46807;21293;20923;28223;25401;21785;18842;20820;18909;17353;19991;25076;24278;25895;22153;14966]';
time = 1:length(num);
data = [time;num];
[data_m,data_n] = size(data);%获取数据维度

index = randperm(data_n);%生成随机序列索引
P = 80;%百分之P的数据用于训练，其余测试
Ind = ceil(P * data_n / 100);

train_index = sort(index(1:Ind));%前60为训练集序列
test_index = sort(index(Ind+1:end));%其余为测试集序列

train_data = data(1,train_index);%由索引获取训练集数据
train_result = data(2,train_index);

test_data = data(1,test_index);%由索引获取测试集数据
test_result = data(2,test_index);

[InDim,TrainSamNum] = size(train_data);% 学习样本数量
[OutDim,TrainSamNum] = size(train_result);
HiddenUnitNum = 20;                    % 隐含层神经元个数

SamIn = mapminmax(train_data,0,1); % 原始样本对（输入和输出）初始化
[SamOut,PS] = mapminmax(train_result,0,1);
MaxEpochs = 300000;    % 最大训练次数
lr = 1e-3;              % 学习率
E0 = 5e-2;              % 目标误差
W1 = rand(HiddenUnitNum, InDim);      % 初始化输入层与隐含层之间的权值
B1 = rand(HiddenUnitNum, 1);          % 初始化输入层与隐含层之间的阈值
W2 = rand(OutDim, HiddenUnitNum);     % 初始化输出层与隐含层之间的权值
B2 = rand(OutDim, 1);                 % 初始化输出层与隐含层之间的阈值
ErrHistory = zeros(MaxEpochs, 1);
m = 1;

for i = 1 : MaxEpochs
    HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % 隐含层网络输出
    NetworkOut_test = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % 输出层网络输出
    Error = SamOut - NetworkOut_test;       % 实际输出与网络输出之差
    SSE = sumsqr(Error);               % 能量函数（误差平方和）
    ErrHistory(i) = SSE;
    
    if SSE < E0
        break;
    end
    
    % 权值（阈值）依据能量函数负梯度下降原理所作的每一步动态调整量
    Delta2 = Error;
    Delta1 = W2' * Delta2 .* HiddenOut .* (1 - HiddenOut);
    dW2 = Delta2 * HiddenOut';
    dB2 = Delta2 * ones(TrainSamNum, 1);
    dW1 = Delta1 * SamIn';
    dB1 = Delta1 * ones(TrainSamNum, 1);
    % 对输出层与隐含层之间的权值和阈值进行修正
    W2 = W2 + lr * dW2;
    B2 = B2 + lr * dB2;
    % 对输入层与隐含层之间的权值和阈值进行修正
    W1 = W1 + lr * dW1;
    B1 = B1 + lr * dB1;
    if mod(i,MaxEpochs/200)==0
        mean_Error(m) = abs(mean(mean(Error)));%平均误差
        fprintf('经%d次训练，误差为%f，用时%fs\n\n',i,SSE,toc);
        E_rr(m) = SSE;%误差
        m = m + 1;
    end
end

Forcast_data = mapminmax('reverse',NetworkOut_test,PS);% 反归一化输出层输出最终结果

figure
subplot(3,1,1);
plot(E_rr,'r')
title('误差迭代曲线')
subplot(3,1,2);
plot(train_result,'o:','LineWidth',1.5)
hold on
plot(Forcast_data,'*-','LineWidth',1.5);
title('训练集拟合效果图')
legend('真实值','拟合值')

% 利用训练好的网络进行预测
[OutDim,ForcastSamNum] = size(test_result);
SamIn_test= mapminmax(test_data,0,1); % 原始样本对（输入和输出）初始化
HiddenOut_test = logsig(W1 * SamIn_test + repmat(B1, 1, ForcastSamNum));  % 隐含层输出预测结果
NetworkOut_test = W2 * HiddenOut_test + repmat(B2, 1, ForcastSamNum);          % 输出层输出预测结果
Forcast_data_test = mapminmax('reverse',NetworkOut_test,PS);

subplot(3,1,3);
plot(test_result,'o:','LineWidth',1.5)
hold on
plot(Forcast_data_test,'*-','LineWidth',1.5);
title('测试集预测效果图')
legend('真实值','预测值')
toc