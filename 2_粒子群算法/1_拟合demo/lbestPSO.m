clear
clc
%*********��ʼ��
M=50;  %��Ⱥ��ģ
k=5;
%��ʼ������λ��
x1=rand(M,1);
x2=rand(M,1);
%x3=rand(M,1);
%X=[x1,x2,x3]
X=[x1,x2];
c1=2;  %ѧϰ����
c2=2;
wmax=0.9;%�����С����Ȩ��
wmin=0.4;
Tmax=50;%��������
%v=zeros(M,3);
v=zeros(M,2);%��ʼ���ٶ�
v1m=50;  %�ٶ�1Լ��
v2m=1;%�ٶ�2Լ��
fmin=inf;
%*******ȫ����������λ�ó�ʼ��
gb=X;
for i=1:M
    for L=i-k:i+k
        if L<1
            L=L+M;
        elseif L>M
            L=L-M;
        end
        if f(X(L,:))<f(gb(i,:))
            gb(i,:)=X(L,:);
        end
    end
    if f(X(i,:))<fmin
        fmin=f(X(i,:));
        best=X(i,:);
    end
end
%********���Ӹ�����ʷ����λ�ó�ʼ��
pb=X;
%********�㷨����
for t=1:Tmax
    t
    w=wmax-(wmax-wmin)*t/Tmax;  %�����½�����Ȩ��
    for i=1:M
        %******���������ٶ�
        v(i,:)=w*v(i,:)+c1*rand(1)*(pb(i,:)-X(i,:))+c2*rand(1)*(gb(i,:)-X(i,:));
        %******�ٶ�Լ��
        if v(i,1)>v1m; v(i,1)=v1m;end
        if v(i,2)>v2m; v(i,2)=v2m; end
        if v(i,1)<-v1m;v(i,1)=-v1m;end
        if v(i,2)<-v2m;v(i,2)=-v1m;end
        %*******��������λ��
        X(i,:)=X(i,:)+v(i,:);
    end
    %����pbest��gbest
    for i=1:M
        if f(X(i,:))<f(pb(i,:))
            pb(i,:)=X(i,:);
        end
        for L=i-k:i+k
            if L<1
                L=L+M;
            elseif L>M
                L=L-M;
            end
            if f(X(L,:))<f(gb(i,:))
                gb(i,:)=X(L,:);
            end
        end
        if f(gb(i,:))<f(best)
            best=gb(i,:);
        end
    end
    %���������Ӧ��
    re(t)=f(best);
end
best
figure
plot(re,'*-','LineWidth',2)
xlabel('��������')
ylabel('��Ӧ��')
re(end)
figure
X=1:15;
Y=[352	211	197	160	142	106	104	60	56	38	36	32	21	19	15];
Y1=best(1)*exp(best(2).*X);
plot(X,Y,'o',X,Y1,':','LineWidth',3);
