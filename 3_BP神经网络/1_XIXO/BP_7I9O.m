clear;
clc;
tic;

% 导入训练数据
data = xlsread('data_7I9O.xlsx');
[data_m,data_n] = size(data);%获取数据维度

index = randperm(data_m);%生成随机序列索引
P = 80;%百分之P的数据用于训练，其余测试
Ind = ceil(P * data_m / 100);
train_index = sort(index(1:Ind));%P%为训练集序列
test_index = sort(index(Ind+1:end));%其余为测试集序列

train_data = data(train_index,1:7)';%由索引获取训练集数据
train_result = data(train_index,8:end)';

test_data = data(test_index,1:7)';%由索引获取测试集数据
test_result = data(test_index,8:end)';

[InDim,TrainSamNum] = size(train_data);% 学习样本数量
[OutDim,TrainSamNum] = size(train_result);
HiddenUnitNum = 9;                    % 隐含层神经元个数

SamIn = mapminmax(train_data,0,1); % 原始样本对（输入和输出）初始化
[SamOut,PS] = mapminmax(train_result,0,1);
MaxEpochs = 100000;    % 最大训练次数
lr = 1e-4;              % 学习率
E0 = 5e-2;              % 目标误差
W1 = rand(HiddenUnitNum, InDim);      % 初始化输入层与隐含层之间的权值
B1 = rand(HiddenUnitNum, 1);          % 初始化输入层与隐含层之间的阈值
W2 = rand(OutDim, HiddenUnitNum);     % 初始化输出层与隐含层之间的权值
B2 = rand(OutDim, 1);                 % 初始化输出层与隐含层之间的阈值
ErrHistory = zeros(MaxEpochs, 1);


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
        fprintf('经%d次训练，误差为%f，用时%fs\n\n',i,SSE,toc);
    end
    mean_Error(i) = abs(mean(mean(Error)));%平均误差
    E_rr(i) = SSE;%误差
    
end

Forcast_data = mapminmax('reverse',NetworkOut_test,PS);% 反归一化输出层输出最终结果

figure
subplot(3,1,1);
plot(E_rr(1:100),'r')%修改这里的100,实现显示前多少个的效果
title('误差迭代曲线')
subplot(3,1,2);
plot(train_result(1,:), 'r-.')
hold on
plot(Forcast_data(1,:), 'b-+');
title('训练集拟合效果图')
legend('真实值','拟合值')

% 利用训练好的网络进行预测
[OutDim,ForcastSamNum] = size(test_result);
SamIn_test= mapminmax(test_data,0,1); % 原始样本对（输入和输出）初始化
HiddenOut_test = logsig(W1 * SamIn_test + repmat(B1, 1, ForcastSamNum));  % 隐含层输出预测结果
NetworkOut_test = W2 * HiddenOut_test + repmat(B2, 1, ForcastSamNum);          % 输出层输出预测结果
Forcast_data_test = mapminmax('reverse',NetworkOut_test,PS);

subplot(3,1,3);
plot(test_result(1,:), 'r-.')
hold on
plot(Forcast_data_test(1,:), 'b-+');
title('测试集预测效果图')
legend('真实值','预测值')
toc