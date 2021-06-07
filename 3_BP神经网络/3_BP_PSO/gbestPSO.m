%����Ⱥ�Ż�����������BP���������
clear
clc
tic
global SamIn SamOut HiddenUnitNum InDim OutDim TrainSamNum
%% ����ѵ������
data = xlsread('data.xlsx');
[data_m,data_n] = size(data);%��ȡ����ά��

P = 80;  %�ٷ�֮P����������ѵ�����������
Ind = floor(P * data_m / 100);

train_data = data(1:Ind,1:4)';
train_result = data(1:Ind,6:7)';
test_data = data(Ind+1:end,1:4)';% ����ѵ���õ��������Ԥ��
test_result = data(Ind+1:end,6:7)';

%% ��ʼ������
[InDim,TrainSamNum] = size(train_data);% ѧϰ��������
[OutDim,TrainSamNum] = size(train_result);
HiddenUnitNum = 8;                     % ��������Ԫ����

[SamIn,PS_i] = mapminmax(train_data,0,1);    % ԭʼ�����ԣ�������������ʼ��
[SamOut,PS_o] = mapminmax(train_result,0,1);

W1 = HiddenUnitNum*InDim;      % ��ʼ���������������֮���Ȩֵ
B1 = HiddenUnitNum;          % ��ʼ���������������֮�����ֵ
W2 = OutDim*HiddenUnitNum;     % ��ʼ���������������֮���Ȩֵ
B2 = OutDim;                % ��ʼ���������������֮�����ֵ
L = W1+B1+W2+B2;        %����ά��

%% *********��ʼ��
M=100;  %��Ⱥ��ģ
%��ʼ������λ��
X=rand(M,L);
c1=2;  %ѧϰ����
c2=2;
wmax=0.9;%�����С����Ȩ��
wmin=0.5;
Tmax=1000;%��������
v=zeros(M,L);%��ʼ���ٶ�
%*******ȫ����������λ�ó�ʼ��
fmin=inf;
for i=1:M
    fx = f(X(i,:));
    if fx<fmin
        fmin=fx;
        gb=X(i,:);
    end
end
%********���Ӹ�����ʷ����λ�ó�ʼ��
pb=X; 
%********�㷨����
for t=1:Tmax
    w(t)=wmax-(wmax-wmin)*t/Tmax;  %�����½�����Ȩ��
    for i=1:M
       %******���������ٶ�
       v(i,:)=w(t)*v(i,:)+c1*rand(1)*(pb(i,:)-X(i,:))+c2*rand(1)*(gb-X(i,:));
       if sum(abs(v(i,:)))>1e3
           v(i,:)=rand(size(v(i,:)));
       end
       %*******��������λ��
       X(i,:)=X(i,:)+v(i,:);
    end
    %����pbest��gbest
    for i=1:M
        if f(X(i,:))<f(pb(i,:))
            pb(i,:)=X(i,:);
        end
        if f(X(i,:))<f(gb)
            gb=X(i,:);
        end
    end
    %���������Ӧ��
    re(t)=f(gb);
    fprintf('��%d��ѵ�������Ϊ%f����ʱ%fs\n\n',t,f(gb),toc);
    %���ӻ���������
    subplot(221)
    plot(gb)
    title('Ȩ��ֵ��������')
    hold on
    subplot(222)
    mesh(v)
    title('�����ٶȱ仯')
    pause(0.000000001)
    subplot(2,2,[3,4])
    plot(re,'r')
    title('�ۼ�����������')
    %74-86�����ӳ�������ʱ�䣬ע�͵��ɼӿ��������
end
x = gb;
W1 = x(1:HiddenUnitNum*InDim);
L1 = length(W1);
W1 = reshape(W1,[HiddenUnitNum, InDim]);
B1 = x(L1+1:L1+HiddenUnitNum)';
L2 = L1 + length(B1);
W2 = x(L2+1:L2+OutDim*HiddenUnitNum);
L3 = L2 + length(W2);
W2 = reshape(W2,[OutDim, HiddenUnitNum]);
B2 = x(L3+1:L3+OutDim)';
HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % �������������
NetworkOut = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % ������������
Error = SamOut - NetworkOut;       % ʵ��������������֮��
Forcast_data = mapminmax('reverse',NetworkOut,PS_o);
[OutDim,ForcastSamNum] = size(test_result);
SamIn_test= mapminmax('apply',test_data,PS_i); % ԭʼ�����ԣ�������������ʼ��
HiddenOut_test = logsig(W1 * SamIn_test + repmat(B1, 1, ForcastSamNum));  % ���������Ԥ����
NetworkOut = W2 * HiddenOut_test + repmat(B2, 1, ForcastSamNum);          % ��������Ԥ����
Forcast_data_test = mapminmax('reverse',NetworkOut,PS_o);

%% ���ƽ��
figure
plot(re,'r')
xlabel('��������')
ylabel('��Ӧ��')
title('�ۼ�����������')
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
title('��1��������Լ�Ԥ��Ч��')
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
title('��2��������Լ�Ԥ��Ч��')
subplot(2,2,3);
stem(train_result(2,:) - Forcast_data(2,:))
title('��2�����ѵ�������')
subplot(2,2,4);
stem(test_result(2,:) - Forcast_data_test(2,:))
title('��2��������Լ����')
toc