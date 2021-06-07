%梯度下降法优化BP神经网络
clear;clc;
tic;

%% 导入训练数据
data = xlsread('data_4I2O.xlsx');
[data_m,data_n] = size(data);%获取数据维度
P = 7;%数据集划分
train_data = data(1:P,1:4)';
train_result = data(1:P,6:7)';
test_data = data(P+1:end,1:4)';% 利用训练好的网络进行预测
test_result = data(P+1:end,6:7)';

%% 初始化参数
[InDim,TrainSamNum] = size(train_data);% 学习样本数量
[OutDim,TrainSamNum] = size(train_result);
HiddenUnitNum = 5;                     % 隐含层神经元个数

[SamIn,PS_i] = mapminmax(train_data,0,1);    % 原始样本对（输入和输出）初始化
[SamOut,PS_o] = mapminmax(train_result,0,1);
MaxEpochs = 200000;       % 最大训练次数
lr = 2e-3;               % 学习率
E0 = 1e-6;              % 目标误差
W1 = rand(HiddenUnitNum, InDim);      % 初始化输入层与隐含层之间的权值
B1 = rand(HiddenUnitNum, 1);          % 初始化输入层与隐含层之间的阈值
W2 = rand(OutDim, HiddenUnitNum);     % 初始化输出层与隐含层之间的权值
B2 = rand(OutDim, 1);                 % 初始化输出层与隐含层之间的阈值
ErrHistory = zeros(MaxEpochs, 1);
m = 1;
%% 开始迭代
for i = 1 : MaxEpochs
    HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % 隐含层网络输出
    NetworkOut = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % 输出层网络输出
    Error = SamOut - NetworkOut;       % 实际输出与网络输出之差
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
        mean_Error(m) = abs(mean(mean(Error)));
        fprintf('经%d次训练，误差为%f，用时%fs\n\n',i,SSE,toc);
        E_rr(m) = SSE;
        m = m + 1;
    end
end
%% 计算结果
HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % 隐含层输出最终结果
NetworkOut = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % 输出层输出最终结果
Forcast_data = mapminmax('reverse',NetworkOut,PS_o);

[OutDim,ForcastSamNum] = size(test_result);
SamIn_test= mapminmax('apply',test_data,PS_i); %原始样本对（输入和输出）初始化
HiddenOut_test = logsig(W1 * SamIn_test + repmat(B1, 1, ForcastSamNum));  % 隐含层输出预测结果
NetworkOut = W2 * HiddenOut_test + repmat(B2, 1, ForcastSamNum);          % 输出层输出预测结果
Forcast_data_test = mapminmax('reverse',NetworkOut,PS_o);

%% 绘制结果
figure
subplot(2,1,1);
plot(E_rr,'r')
title('累计误差迭代曲线')
subplot(2,1,2);
plot(mean_Error)
title('平均误差迭代曲线')

figure
subplot(2,2,1);
plot(train_result(1,:), 'r-*')
hold on
plot(Forcast_data(1,:), 'b-o');
legend('真实值','拟合值')
title('第1个输出训练集拟合效果')
subplot(2,2,2);
plot(test_result(1,:), 'r-*')
hold on
plot(Forcast_data_test(1,:), 'b-o');
legend('真实值','预测值')
title('第1个输出测试集拟合效果')
subplot(2,2,3);
stem(train_result(1,:) - Forcast_data(1,:))
title('第1个输出训练集误差')
subplot(2,2,4);
stem(test_result(1,:) - Forcast_data_test(1,:))
title('第1个输出测试集误差')

figure
subplot(2,2,1);
plot(train_result(2,:), 'r-*')
hold on
plot(Forcast_data(2,:), 'b-o');
legend('真实值','拟合值')
title('第2个输出训练集拟合效果')
subplot(2,2,2);
plot(test_result(2,:), 'r-*')
hold on
plot(Forcast_data_test(2,:), 'b-o');
legend('真实值','预测值')
title('第2个输出测试集拟合效果')
subplot(2,2,3);
stem(train_result(2,:) - Forcast_data(2,:))
title('第2个输出训练集误差')
subplot(2,2,4);
stem(test_result(2,:) - Forcast_data_test(2,:))
title('第2个输出测试集误差')
