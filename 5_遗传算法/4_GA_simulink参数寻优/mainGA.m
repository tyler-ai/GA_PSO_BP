clear
clc
tic
global kp ki kd
N = 30;%��ʼ����Ⱥ��ģ
T = 30;%��ʼ����������
pc = 0.9;%�������
pm = 0.1;%�������
per = 2;%��⾫�ȣ�С�����λ
a1 = 0;b1 = 10; %kp��Χ,����һά�ȣ�
a2 = 0;b2 = 300;%ki��Χ,���ڶ�ά�ȣ�
a3 = 0;b3 = 1;  %kd��Χ,������ά�ȣ�
L1 = ceil(log2((b1 - a1) * 10^per));%����kp���볤��
L2 = ceil(log2((b2 - a2) * 10^per));%����ki���볤��
L3 = ceil(log2((b3 - a3) * 10^per));%����kd���볤��
L = L1 + L2 + L3;%Ⱦɫ���ܳ���
pop = round(rand(N,L));%��ʼ����Ⱥ
maxf = -inf;
for i = 1:N
    x1(i)=bin2dec(num2str(pop(i,1:L1)))*(b1-a1)/(2^L1-1)+a1;%����kp
    x2(i)=bin2dec(num2str(pop(i,L1+1:L1+L2)))*(b2-a2)/(2^L2-1)+a2;%����ki
    x3(i)=bin2dec(num2str(pop(i,L1+L2+1:end)))*(b3-a3)/(2^L3-1)+a3;%����kd
    x(1,:)=[x1(i),x2(i),x3(i)];
    y(i)=f(x(1,:));%���������Ӧ��
    if y(i)>maxf
        maxf=y(i);%��������
        opmx=x(1,:);
    end
end

for t=1:T
    
    %select
    p=y/sum(y);%���̶�ѡ��
    q=cumsum(p);
    for i=1:N
        temp=rand(1);
        Ind=find(q>=temp);%����ָ���������
        s2(i,:)=pop(Ind(1),:);
    end
    %crossover
    for i=1:N
        if rand(1)<pc%�����ж�
            I=randi([1,N]);
            J=randi([1,N]);
            if I~=J
                k1=randi([1,L]);
                k2=randi([1,L]);
                if k1>k2 || k1==k2%���㽻��
                    temp = s2(I,k1+1:end);
                    s2(I,k1+1:end)= s2(J,k1+1:end);
                    s2(J,k1+1:end)= temp;
                else%˫�㽻��
                    temp = s2(I,k1+1:k2);
                    s2(I,k1+1:k2)= s2(J,k1+1:k2);
                    s2(J,k1+1:k2)= temp;
                end
            end
        end
    end
    %mututation
    for i=1:N
        if rand(1)<pm%�����ж�
            I=1+fix((N-1)*rand(1));%�������
            k=1+fix((L-1)*rand(1));%����λ��
            s2(I,k)=1-s2(I,k);%����
        end
    end
    %������Ⱥ
    pop=s2;
    for i=1:N
        x1(i)=bin2dec(num2str(pop(i,1:L1)))*(b1-a1)/(2^L1-1)+a1;%����kp
        x2(i)=bin2dec(num2str(pop(i,L1+1:L1+L2)))*(b2-a2)/(2^L2-1)+a2;%����ki
        x3(i)=bin2dec(num2str(pop(i,L1+L2+1:end)))*(b3-a3)/(2^L3-1)+a3;%����kd
        x(1,:)=[x1(i),x2(i),x3(i)];
        y(i)=f(x(1,:));%������Ӧ��
        if y(i)>maxf
            maxf=y(i);
            opmx=x(1,:);
        end
    end
    max_f(t)=maxf;%����������Ӧ��
    mean_f(t)=mean(y);%������Ⱥƽ����Ӧ��
    fprintf('��%d����������Ӧ��ֵΪ��%f\n\n',t,maxf)
end

figure
plot(1:T,max_f,'b',1:T,mean_f,'g','LineWidth',2)
legend('��Ⱥ������Ӧ��ֵ��������','��Ⱥƽ����Ӧ��ֵ��������','Location','southeast')
xlabel('��������')
ylabel('��Ӧ��ֵ')
maxf
opm_kp = opmx(1)
opm_ki = opmx(2)
opm_kd = opmx(3)
sim_time = 5;
sim_step = 1000;
%����ʱ���
for i=1:sim_step
    time_stamp(i,1) = i * sim_time / sim_step;
end
%��������
kp = [time_stamp,ones(sim_step,1)*opm_kp];
ki = [time_stamp,ones(sim_step,1)*opm_ki];
kd = [time_stamp,ones(sim_step,1)*opm_kd];

sim('pid3.slx',[0,5]);
figure
plot(Data_out.Time,Data_out.Data,'LineWidth',2);%����Ѱ�ŷ�������
hold on

kp = [time_stamp,ones(sim_step,1)*1];
ki = [time_stamp,ones(sim_step,1)*150];
kd = [time_stamp,ones(sim_step,1)*0.001];
sim('pid3.slx',[0,5]);
plot(Data_out.Time,Data_out.Data,'LineWidth',2);%�����趨��������
legend('Ѱ�Ų��� opmx','�趨���� [1 150 0.001]')
toc