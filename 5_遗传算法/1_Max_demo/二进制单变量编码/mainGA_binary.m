clear
clc
N=30;%��Ⱥ��ģ
T=100;%��������
pc=0.9;%�������
pm=0.1;%�������
per=3;%��⾫��
a=-1;b=5;%������
xx=a:0.001:b;
yy=exp(xx).*cos(10*pi*xx)+5;
L=ceil(log2((b-a)*10^per));%�볤
s=round(rand(N,L));
maxf=0;
for i=1:N
    x(i)=bin2dec(num2str(s(i,:)))*(b-a)/(2^L-1)+a;%����
    y(i)=f(x(i));
    if y(i)>maxf
        maxf=y(i);
        opmx=x(i);
    end
end
for t=1:T
    t
    %select
    p=(y+50)/sum(y+50);
    q=cumsum(p);
    for i=1:N
        temp=rand(1);
        Ind=find(q>=temp);
        s2(i,:)=s(Ind(1),:);
    end
    %crossover
    for i=1:N
        if rand(1)<pc
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
        if rand(1)<pm
            I=1+fix((N-1)*rand(1));
            k=1+fix((L-1)*rand(1));
            s2(I,k)=1-s2(I,k);
        end
    end
    %renew
    s=s2;
    for i=1:N
        x(i)=bin2dec(num2str(s(i,:)))*(b-a)/(2^L-1)+a;
        y(i)=f(x(i));
        if y(i)>maxf
            maxf=y(i);
            opmx=x(i);
        end
    end
    
    pause(0.05)%ȥ��ע��ʵ�ֶ�̬Ч��
    plot(xx,yy,'b')
    hold on
    plot(x,y,'k*')
    plot(opmx,maxf,'rp' ,'LineWidth',3, 'MarkerFaceColor','b')
    hold off
    max_f(t)=maxf;
    mean_f(t)=mean(y);
end
legend('Ŀ�꺯������','��Ⱥ����ֲ�','���Ÿ���ֵ','Location','NorthWest')

figure
aaa = max_f;
plot(1:T,aaa,'b')%,1:T,mean_f,'g','LineWidth',2)
%legend('������Ӧ��ֵ')%,'ƽ����Ӧ��ֵ')
xlabel('��������')
ylabel('��Ӧ��ֵ')
maxf
opmx