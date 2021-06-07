clear;
clc;
tic;

% ����ѵ������


num = [0;0;0;0;0;0;0;0;0;0;0;0;6;6;5;20;16;15;31;79;110;103;119;123;55;262;455;720;393;244;950;895;1823;3775;4008;5357;7123;14961;11947;11238;17511;18313;20400;18353;20550;26245;19543;29251;20871;34676;31156;30784;30710;36082;33649;37455;30881;26163;25101;20502;39789;20181;30593;41672;21055;14191;27434;36863;17165;28436;34567;34200;33734;35097;47237;33433;34009;32693;27901;24856;25108;23051;31697;30635;23117;23153;16141;21280;6259;20018;22939;24284;25697;46807;21293;20923;28223;25401;21785;18842;20820;18909;17353;19991;25076;24278;25895;22153;14966]';
time = 1:length(num);
data = [time;num];
[data_m,data_n] = size(data);%��ȡ����ά��

index = randperm(data_n);%���������������
P = 80;%�ٷ�֮P����������ѵ�����������
Ind = ceil(P * data_n / 100);

train_index = sort(index(1:Ind));%ǰ60Ϊѵ��������
test_index = sort(index(Ind+1:end));%����Ϊ���Լ�����

train_data = data(1,train_index);%��������ȡѵ��������
train_result = data(2,train_index);

test_data = data(1,test_index);%��������ȡ���Լ�����
test_result = data(2,test_index);

[InDim,TrainSamNum] = size(train_data);% ѧϰ��������
[OutDim,TrainSamNum] = size(train_result);
HiddenUnitNum = 20;                    % ��������Ԫ����

SamIn = mapminmax(train_data,0,1); % ԭʼ�����ԣ�������������ʼ��
[SamOut,PS] = mapminmax(train_result,0,1);
MaxEpochs = 300000;    % ���ѵ������
lr = 1e-3;              % ѧϰ��
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
plot(train_result,'o:','LineWidth',1.5)
hold on
plot(Forcast_data,'*-','LineWidth',1.5);
title('ѵ�������Ч��ͼ')
legend('��ʵֵ','���ֵ')

% ����ѵ���õ��������Ԥ��
[OutDim,ForcastSamNum] = size(test_result);
SamIn_test= mapminmax(test_data,0,1); % ԭʼ�����ԣ�������������ʼ��
HiddenOut_test = logsig(W1 * SamIn_test + repmat(B1, 1, ForcastSamNum));  % ���������Ԥ����
NetworkOut_test = W2 * HiddenOut_test + repmat(B2, 1, ForcastSamNum);          % ��������Ԥ����
Forcast_data_test = mapminmax('reverse',NetworkOut_test,PS);

subplot(3,1,3);
plot(test_result,'o:','LineWidth',1.5)
hold on
plot(Forcast_data_test,'*-','LineWidth',1.5);
title('���Լ�Ԥ��Ч��ͼ')
legend('��ʵֵ','Ԥ��ֵ')
toc