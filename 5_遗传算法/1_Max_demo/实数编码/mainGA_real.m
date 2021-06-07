clear
clc
tic
N=30;%��Ⱥ��ģ
T=100;%��������
pc=0.88;%�������
pm=0.1;%�������
dim = 4;%��������
X=10*rand(N,dim)-5;%��ʼ����Ⱥ
maxf=-inf;%��ʼ��������Ӧ��ֵ
for i=1:N%������Ӧ��ֵ
    y(i)=f(X(i,:));%����ÿ��������Ӧ��ֵ
    if y(i)>maxf %�ж�ÿ�������Ƿ��������Ÿ���
        maxf=y(i);%����������Ӧ��ֵ
        opmx=X(i,:);%�������Ÿ���
    end
end
for t=1:T%��ʼ����
    t
    %���̶�ѡ��
    p=(y+50)/sum(y+50);%�õ�ÿ����������Ⱥ��Ӧ��֮���е�ռ��
    q=cumsum(p);%�ۼ�ռ����Ӧ��
    for i=1:N
        temp=rand(1);%���������
        Ind=find(q>=temp);%�õ�ѡ����������
        X2(i,:)=X(Ind(1),:);%Ϊ����Ⱥ��ֵ
    end
    %����
    for i=1:N
        if rand(1)<pc%�ж��Ƿ񽻲�
            I=randi([1,N]);%�õ��������1
            J=randi([1,N]);%�õ��������2
            while I==J%�������Ƿ�Ϊͬһ��
                I=randi([1,N]);
                J=randi([1,N]);
            end
            k=randi([1,dim]);%�õ�����ڵ�
            temp = X2(I,k+1:end);%�滻����
            X2(I,k+1:end)= X2(J,k+1:end);
            X2(J,k+1:end)= temp;
        end
    end
    %����
    Mu = rand(N,dim);%�������
    X2 = (Mu>=pm).*X2 + (Mu<pm).*Mu;%���ʴ��ڱ�����ʲ��䣬С�����滻
    %����
    X=X2;
    for i=1:N
        y(i)=f(X(i,:));%����ÿ��������Ӧ��ֵ
        if y(i)>maxf%�ж�ÿ�������Ƿ��������Ÿ���
            maxf=y(i);%����������Ӧ��ֵ
            opmx=X(i,:);%�������Ÿ���
        end
    end
    max_f(t)=maxf;%��¼ÿһ������
    mean_f(t)=mean(y);%��¼ÿһ����Ⱥ��Ӧ�Ⱦ�ֵ
end
%���Ʋ���ӡ���
plot(1:T,max_f,1:T,mean_f,'LineWidth',2)
legend('������Ӧ��ֵ','��Ⱥƽ����Ӧ��ֵ','Location','SouthEast')
xlabel('��������')
ylabel('��Ӧ��ֵ')
opmx
maxf
toc%��ӡ��ʱ