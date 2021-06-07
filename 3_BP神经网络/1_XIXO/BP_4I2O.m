%�ݶ��½����Ż�BP������
clear;clc;
tic;

%% ����ѵ������
data = xlsread('data_4I2O.xlsx');
[data_m,data_n] = size(data);%��ȡ����ά��
P = 7;%���ݼ�����
train_data = data(1:P,1:4)';
train_result = data(1:P,6:7)';
test_data = data(P+1:end,1:4)';% ����ѵ���õ��������Ԥ��
test_result = data(P+1:end,6:7)';

%% ��ʼ������
[InDim,TrainSamNum] = size(train_data);% ѧϰ��������
[OutDim,TrainSamNum] = size(train_result);
HiddenUnitNum = 5;                     % ��������Ԫ����

[SamIn,PS_i] = mapminmax(train_data,0,1);    % ԭʼ�����ԣ�������������ʼ��
[SamOut,PS_o] = mapminmax(train_result,0,1);
MaxEpochs = 200000;       % ���ѵ������
lr = 2e-3;               % ѧϰ��
E0 = 1e-6;              % Ŀ�����
W1 = rand(HiddenUnitNum, InDim);      % ��ʼ���������������֮���Ȩֵ
B1 = rand(HiddenUnitNum, 1);          % ��ʼ���������������֮�����ֵ
W2 = rand(OutDim, HiddenUnitNum);     % ��ʼ���������������֮���Ȩֵ
B2 = rand(OutDim, 1);                 % ��ʼ���������������֮�����ֵ
ErrHistory = zeros(MaxEpochs, 1);
m = 1;
%% ��ʼ����
for i = 1 : MaxEpochs
    HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % �������������
    NetworkOut = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % ������������
    Error = SamOut - NetworkOut;       % ʵ��������������֮��
    SSE = sumsqr(Error);               % �������������ƽ���ͣ�
    ErrHistory(i) = SSE;
    if SSE < E0
        break;
    end
    % Ȩֵ����ֵ�����������������ݶ��½�ԭ��������ÿһ����̬������
    Delta2 = Error;
    Delta1 = W2' * Delta2 .* HiddenOut .* (1 - HiddenOut);
    dW2 = Delta2 * HiddenOut';
    dB2 = Delta2 * ones(TrainSamNum, 1);
    dW1 = Delta1 * SamIn';
    dB1 = Delta1 * ones(TrainSamNum, 1);
    % ���������������֮���Ȩֵ����ֵ��������
    W2 = W2 + lr * dW2;
    B2 = B2 + lr * dB2;
    % ���������������֮���Ȩֵ����ֵ��������
    W1 = W1 + lr * dW1;
    B1 = B1 + lr * dB1;
    if mod(i,MaxEpochs/200)==0
        mean_Error(m) = abs(mean(mean(Error)));
        fprintf('��%d��ѵ�������Ϊ%f����ʱ%fs\n\n',i,SSE,toc);
        E_rr(m) = SSE;
        m = m + 1;
    end
end
%% ������
HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % ������������ս��
NetworkOut = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % �����������ս��
Forcast_data = mapminmax('reverse',NetworkOut,PS_o);

[OutDim,ForcastSamNum] = size(test_result);
SamIn_test= mapminmax('apply',test_data,PS_i); %ԭʼ�����ԣ�������������ʼ��
HiddenOut_test = logsig(W1 * SamIn_test + repmat(B1, 1, ForcastSamNum));  % ���������Ԥ����
NetworkOut = W2 * HiddenOut_test + repmat(B2, 1, ForcastSamNum);          % ��������Ԥ����
Forcast_data_test = mapminmax('reverse',NetworkOut,PS_o);

%% ���ƽ��
figure
subplot(2,1,1);
plot(E_rr,'r')
title('�ۼ�����������')
subplot(2,1,2);
plot(mean_Error)
title('ƽ������������')

figure
subplot(2,2,1);
plot(train_result(1,:), 'r-*')
hold on
plot(Forcast_data(1,:), 'b-o');
legend('��ʵֵ','���ֵ')
title('��1�����ѵ�������Ч��')
subplot(2,2,2);
plot(test_result(1,:), 'r-*')
hold on
plot(Forcast_data_test(1,:), 'b-o');
legend('��ʵֵ','Ԥ��ֵ')
title('��1��������Լ����Ч��')
subplot(2,2,3);
stem(train_result(1,:) - Forcast_data(1,:))
title('��1�����ѵ�������')
subplot(2,2,4);
stem(test_result(1,:) - Forcast_data_test(1,:))
title('��1��������Լ����')

figure
subplot(2,2,1);
plot(train_result(2,:), 'r-*')
hold on
plot(Forcast_data(2,:), 'b-o');
legend('��ʵֵ','���ֵ')
title('��2�����ѵ�������Ч��')
subplot(2,2,2);
plot(test_result(2,:), 'r-*')
hold on
plot(Forcast_data_test(2,:), 'b-o');
legend('��ʵֵ','Ԥ��ֵ')
title('��2��������Լ����Ч��')
subplot(2,2,3);
stem(train_result(2,:) - Forcast_data(2,:))
title('��2�����ѵ�������')
subplot(2,2,4);
stem(test_result(2,:) - Forcast_data_test(2,:))
title('��2��������Լ����')
