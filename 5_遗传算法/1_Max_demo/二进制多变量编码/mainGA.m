clear
clc
tic
N = 100;%��ʼ����Ⱥ��ģ
T = 100;%��ʼ����������
pc = 0.9;%�������
pm = 0.1;%�������
per = 2;%��⾫�ȣ�С�����λ
a1 = 0;b1 = 10;%x1��Χ
a2 = 0;b2 = 300;%x2��Χ
a3 = 0;b3 = 1;%x3��Χ
L1 = ceil(log2((b1 - a1) * 10^per));%����x1���볤��
L2 = ceil(log2((b2 - a2) * 10^per));%����x2���볤��
L3 = ceil(log2((b3 - a3) * 10^per));%����x3���볤��
L = L1 + L2 + L3;%Ⱦɫ���ܳ���
pop = round(rand(N,L));%��ʼ����Ⱥ
maxf = -inf;
for i = 1:N
    x1(i)=bin2dec(num2str(pop(i,1:L1)))*(b1-a1)/(2^L1-1)+a1;%����x1
    x2(i)=bin2dec(num2str(pop(i,L1+1:L1+L2)))*(b2-a2)/(2^L2-1)+a2;%����x2
    x3(i)=bin2dec(num2str(pop(i,L1+L2+1:end)))*(b3-a3)/(2^L3-1)+a3;%����x3
    x(1,:)=[x1(i),x2(i),x3(i)];
    y(i)=f(x(1,:));%���������Ӧ��
    if y(i)>maxf
        maxf=y(i);%��������
        opmx=x(1,:);
    end
end
for t=1:T
    t
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
        x1(i)=bin2dec(num2str(pop(i,1:L1)))*(b1-a1)/(2^L1-1)+a1;%����x1
        x2(i)=bin2dec(num2str(pop(i,L1+1:L1+L2)))*(b2-a2)/(2^L2-1)+a2;%����x2
        x3(i)=bin2dec(num2str(pop(i,L1+L2+1:end)))*(b3-a3)/(2^L3-1)+a3;%����x3
        x(1,:)=[x1(i),x2(i),x3(i)];
        y(i)=f(x(1,:));%������Ӧ��
        if y(i)>maxf
            maxf=y(i);
            opmx=x(1,:);
        end
    end
    max_f(t)=maxf;%����������Ӧ��
    mean_f(t)=mean(y);%������Ⱥƽ����Ӧ��
end

figure
plot(1:T,max_f,'b',1:T,mean_f,'g','LineWidth',2)
legend('��Ⱥ������Ӧ��ֵ��������','��Ⱥƽ����Ӧ��ֵ��������','Location','southeast')
xlabel('��������')
ylabel('��Ӧ��ֵ')
maxf
opm_x1 = opmx(1)
opm_x2 = opmx(2)
opm_x3 = opmx(3)
toc