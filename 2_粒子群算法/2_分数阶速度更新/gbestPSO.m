clear
clc
%*********��ʼ��
M=100;  %��Ⱥ��ģ
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
alph = 0.5;  
vt_1 = v;
vt_2 = v;
vt_3 = v;
%*******ȫ����������λ�ó�ʼ��
fmin=1000;
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
        v(i,:)=alph*v(i,:)+...
            1/2*alph*(1-alph)*vt_1(i,:)+...
            1/6*alph*(1-alph)*(2-alph)*vt_2(i,:)+...
            1/24*alph*(1-alph)*(2-alph)*(3-alph)*vt_3(i,:)+...
            c1*rand*(pb(i,:)-X(i,:))+c2*rand*(gb-X(i,:));
        vt_3(i,:) = vt_2(i,:);%��������v(t-3)
        vt_2(i,:) = vt_1(i,:);%��������v(t-2)
        vt_1(i,:) = v(i,:);%��������v(t-1)
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
% X=[1,3,4,5,6,7,8,9,10];
% Y=[10,5,4,2,1,1,2,3,4];
% Y1=gb(1)*X.^2+gb(2)*X+gb(3);
X=1:15;
Y=[352	211	197	160	142	106	104	60	56	38	36	32	21	19	15];
Y1=gb(1)*exp(gb(2).*X);
plot(X,Y,'o',X,Y1,':','LineWidth',2);
