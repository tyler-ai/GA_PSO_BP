%% ��ջ���
clear
clc

%% ��������
w = 0.6;      % ��������
c1 = 2;       % ���ٳ���
c2 = 2;       % ���ٳ���

Dim = 3;            % ά��
SwarmSize = 100;    % ����Ⱥ��ģ
ObjFun = @PSO_PID;  % ���Ż��������

MaxIter = 100;      % ����������
MinFit = 0.1;       % ��С��Ӧֵ

Vmax = 1;
Vmin = -1;
Ub = [300 300 300];
Lb = [0 0 0];

%% ����Ⱥ��ʼ��
Range = ones(SwarmSize,1)*(Ub-Lb);
Swarm = rand(SwarmSize,Dim).*Range + ones(SwarmSize,1)*Lb;      % ��ʼ������Ⱥ
VStep = rand(SwarmSize,Dim)*(Vmax-Vmin) + Vmin;                 % ��ʼ���ٶ�
fSwarm = zeros(SwarmSize,1);
for i=1:SwarmSize
    fSwarm(i,:) = feval(ObjFun,Swarm(i,:));                         % ����Ⱥ����Ӧֵ
end

%% ���弫ֵ��Ⱥ�弫ֵ
[bestf bestindex]=min(fSwarm);
zbest=Swarm(bestindex,:);   % ȫ�����
gbest=Swarm;                % �������
fgbest=fSwarm;              % ���������Ӧֵ
fzbest=bestf;               % ȫ�������Ӧֵ

%% ����Ѱ��
T = 1;
y_fitness = zeros(1,MaxIter);   % Ԥ�Ȳ���4���վ���
K_p = zeros(1,MaxIter);
K_i = zeros(1,MaxIter);
K_d = zeros(1,MaxIter);
while( (T <= MaxIter) && (fzbest > MinFit) )
    T
    for j=1:SwarmSize
        % �ٶȸ���
        VStep(j,:) = w*VStep(j,:) + c1*rand*(gbest(j,:) - Swarm(j,:)) + c2*rand*(zbest - Swarm(j,:));
        if VStep(j,:)>Vmax, VStep(j,:)=Vmax; end
        if VStep(j,:)<Vmin, VStep(j,:)=Vmin; end
        % λ�ø���
        Swarm(j,:)=Swarm(j,:)+VStep(j,:);
        for k=1:Dim
            if Swarm(j,k)>Ub(k), Swarm(j,k)=Ub(k); end
            if Swarm(j,k)<Lb(k), Swarm(j,k)=Lb(k); end
        end
        % ��Ӧֵ
        fSwarm(j,:) = feval(ObjFun,Swarm(j,:));
        % �������Ÿ���
        if fSwarm(j) < fgbest(j)
            gbest(j,:) = Swarm(j,:);
            fgbest(j) = fSwarm(j);
        end
        % Ⱥ�����Ÿ���
        if fSwarm(j) < fzbest
            zbest = Swarm(j,:);
            fzbest = fSwarm(j);
        end
    end
    T = T + 1;                         % ������������
    y_fitness(1,T) = fzbest;           % Ϊ��ͼ��׼��
    K_p(1,T) = zbest(1);
    K_i(1,T) = zbest(2);
    K_d(1,T) = zbest(3);
end

%% ��ͼ���
figure% ��������ָ��ITAE�ı仯����
plot(y_fitness,'LineWidth',2)
title('���Ÿ�����Ӧֵ');
xlabel('��������');
ylabel('��Ӧֵ');
figure% ����PID�����������仯����
plot(K_p)
hold on
plot(K_i,'k','LineWidth',3)
plot(K_d,'--r')
title('Kp��Ki��Kd �Ż�����');
xlabel('��������');
ylabel('����ֵ');
legend('Kp','Ki','Kd');