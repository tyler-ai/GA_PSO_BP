clear;
clc;
tic;

% ����ѵ������
data = xlsread('data_4I1O.xlsx');
[data_m,data_n] = size(data);%��ȡ����ά��

index = randperm(data_n);%���������������
P = 90;%�ٷ�֮P����������ѵ�����������
Ind = ceil(P * data_n / 100);
train_index = sort(index(1:Ind));%ǰ60Ϊѵ��������
test_index = sort(index(Ind+1:end));%����Ϊ���Լ�����

train_data = data(1:4,train_index);%��������ȡѵ��������
train_result = data(7,train_index);

test_data = data(1:4,test_index);%��������ȡ���Լ�����
test_result = data(7,test_index);

[InDim,TrainSamNum] = size(train_data);% ѧϰ��������
[OutDim,TrainSamNum] = size(train_result);
HiddenUnitNum = 9;                    % ��������Ԫ����

SamIn = mapminmax(train_data,0,1); % ԭʼ�����ԣ�������������ʼ��
[SamOut,PS] = mapminmax(train_result,0,1);
MaxEpochs = 300000;    % ���ѵ������
lr = 2e-3;              % ѧϰ��
E0 = 5e-2;              % Ŀ�����
W1 = rand(HiddenUnitNum, InDim);      % ��ʼ���������������֮���Ȩֵ
B1 = rand(HiddenUnitNum, 1);          % ��ʼ���������������֮�����ֵ
W2 = rand(OutDim, HiddenUnitNum);     % ��ʼ���������������֮���Ȩֵ
B2 = rand(OutDim, 1);                 % ��ʼ���������������֮�����ֵ
ErrHistory = zeros(MaxEpochs, 1);
m = 1;

for i = 1 : MaxEpochs
    HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % �������������
    NetworkOut_test = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % ������������
    Error = SamOut - NetworkOut_test;       % ʵ��������������֮��
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
        mean_Error(m) = abs(mean(mean(Error)));%ƽ�����
        fprintf('��%d��ѵ�������Ϊ%f����ʱ%fs\n\n',i,SSE,toc);
        E_rr(m) = SSE;%���
        m = m + 1;
    end
end

Forcast_data = mapminmax('reverse',NetworkOut_test,PS);% ����һ�������������ս��

figure
subplot(3,1,1);
plot(E_rr,'r')
title('����������')
subplot(3,1,2);
plot(train_result, 'r-.')
hold on
plot(Forcast_data, 'b-+');
title('ѵ�������Ч��ͼ')
legend('��ʵֵ','���ֵ')

% ����ѵ���õ��������Ԥ��
[OutDim,ForcastSamNum] = size(test_result);
SamIn_test= mapminmax(test_data,0,1); % ԭʼ�����ԣ�������������ʼ��
HiddenOut_test = logsig(W1 * SamIn_test + repmat(B1, 1, ForcastSamNum));  % ���������Ԥ����
NetworkOut_test = W2 * HiddenOut_test + repmat(B2, 1, ForcastSamNum);          % ��������Ԥ����
Forcast_data_test = mapminmax('reverse',NetworkOut_test,PS);

subplot(3,1,3);
plot(test_result, 'r-.')
hold on
plot(Forcast_data_test, 'b-+');
title('���Լ�Ԥ��Ч��ͼ')
legend('��ʵֵ','Ԥ��ֵ')
toc