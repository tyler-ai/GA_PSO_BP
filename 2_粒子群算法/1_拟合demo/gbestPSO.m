clear
clc
%*********��ʼ��
M = 100;  %��Ⱥ��ģ
%��ʼ������λ��
X = rand(M,2);;
c1 = 2;  %ѧϰ����
c2 = 2;
wmax = 0.9;%�����С����Ȩ��
wmin = 0.4;
Tmax = 50;%��������
v = zeros(M,2);%��ʼ���ٶ�
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
    t
    w(t)=wmax-(wmax-wmin)*t/Tmax;  %�����½�����Ȩ��
    for i=1:M
        %******���������ٶ�
        v(i,:)=w(t)*v(i,:)+c1*rand(1)*(pb(i,:)-X(i,:))+c2*rand(1)*(gb-X(i,:));

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
end
figure
plot(re,'-*','LineWidth',2)
xlabel('��������')
ylabel('��Ӧ��')
gb
re(end)
figure
X=1:15;
Y=[352	211	197	160	142	106	104	60	56	38	36	32	21	19	15];
Y1=gb(1)*exp(gb(2).*X);
plot(X,Y,'o',X,Y1,':','LineWidth',2);
