clc;clear

%% ��������
data=load('eil51.txt');
cityCoor=[data(:,2) data(:,3)];%�����������

figure
plot(cityCoor(:,1),cityCoor(:,2),'ms','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g')
legend('����λ��')
ylim([4 78])
title('���зֲ�ͼ','fontsize',12)
xlabel('km','fontsize',12)
ylabel('km','fontsize',12)
ylim([min(cityCoor(:,2))-1 max(cityCoor(:,2))+1])

grid on

%% ������м����
n=size(cityCoor,1);            %������Ŀ
cityDist=zeros(n,n);           %���о������
for i=1:n
    for j=1:n
        if i~=j
            cityDist(i,j)=((cityCoor(i,1)-cityCoor(j,1))^2+...
                (cityCoor(i,2)-cityCoor(j,2))^2)^0.5;
        end
        cityDist(j,i)=cityDist(i,j);
    end
end
nMax=500;                      %��������
indiNumber=300;                %������Ŀ
individual=zeros(indiNumber,n);
%^��ʼ������λ��
for i=1:indiNumber
    individual(i,:)=randperm(n);
end

%% ������Ⱥ��Ӧ��
indiFit=fitness(individual,cityCoor,cityDist);
[value,index]=min(indiFit);
tourPbest=individual;                              %��ǰ��������
tourGbest=individual(index,:) ;                    %��ǰȫ������
recordPbest=inf*ones(1,indiNumber);                %�������ż�¼
recordGbest=indiFit(index);                        %Ⱥ�����ż�¼
xnew1=individual;

%% ѭ��Ѱ������·��
L_best=zeros(1,nMax);
for N=1:nMax
    %������Ӧ��ֵ
    indiFit=fitness(individual,cityCoor,cityDist);
    
    %���µ�ǰ���ź���ʷ����
    for i=1:indiNumber
        if indiFit(i)<recordPbest(i)
            recordPbest(i)=indiFit(i);
            tourPbest(i,:)=individual(i,:);
        end
        if indiFit(i)<recordGbest
            recordGbest=indiFit(i);
            tourGbest=individual(i,:);
        end
    end
    
    [value,index]=min(recordPbest);
    recordGbest(N)=recordPbest(index);
    
    fprintf('��%d��������·������Ϊ��%1.10f\n\n',N,value)
    %% �������
    for i=1:indiNumber
        % ��������Ž��н���
        c1=unidrnd(n-1); %��������λ
        c2=unidrnd(n-1); %��������λ
        while c1==c2
            c1=round(rand*(n-2))+1;
            c2=round(rand*(n-2))+1;
        end
        chb1=min(c1,c2);
        chb2=max(c1,c2);
        cros=tourPbest(i,chb1:chb2);
        ncros=size(cros,2);
        %ɾ���뽻��������ͬԪ��
        for j=1:ncros
            for k=1:n
                if xnew1(i,k)==cros(j)
                    xnew1(i,k)=0;
                    for t=1:n-k
                        temp=xnew1(i,k+t-1);
                        xnew1(i,k+t-1)=xnew1(i,k+t);
                        xnew1(i,k+t)=temp;
                    end
                end
            end
        end
        %���뽻������
        xnew1(i,n-ncros+1:n)=cros;
        %��·�����ȱ�������
        dist=0;
        for j=1:n-1
            dist=dist+cityDist(xnew1(i,j),xnew1(i,j+1));
        end
        dist=dist+cityDist(xnew1(i,1),xnew1(i,n));
        if indiFit(i)>dist
            individual(i,:)=xnew1(i,:);
        end
        
        % ��ȫ�����Ž��н���
        c1=round(rand*(n-2))+1;  %��������λ
        c2=round(rand*(n-2))+1;  %��������λ
        while c1==c2
            c1=round(rand*(n-2))+1;
            c2=round(rand*(n-2))+1;
        end
        chb1=min(c1,c2);
        chb2=max(c1,c2);
        cros=tourGbest(chb1:chb2);
        ncros=size(cros,2);
        %ɾ���뽻��������ͬԪ��
        for j=1:ncros
            for k=1:n
                if xnew1(i,k)==cros(j)
                    xnew1(i,k)=0;
                    for t=1:n-k
                        temp=xnew1(i,k+t-1);
                        xnew1(i,k+t-1)=xnew1(i,k+t);
                        xnew1(i,k+t)=temp;
                    end
                end
            end
        end
        %���뽻������
        xnew1(i,n-ncros+1:n)=cros;
        %��·�����ȱ�������
        dist=0;
        for j=1:n-1
            dist=dist+cityDist(xnew1(i,j),xnew1(i,j+1));
        end
        dist=dist+cityDist(xnew1(i,1),xnew1(i,n));
        if indiFit(i)>dist
            individual(i,:)=xnew1(i,:);
        end
        
        %% �������
        c1=round(rand*(n-1))+1;   %��������λ
        c2=round(rand*(n-1))+1;   %��������λ
        while c1==c2
            c1=round(rand*(n-2))+1;
            c2=round(rand*(n-2))+1;
        end
        temp=xnew1(i,c1);
        xnew1(i,c1)=xnew1(i,c2);
        xnew1(i,c2)=temp;
        
        %��·�����ȱ�������
        dist=0;
        for j=1:n-1
            dist=dist+cityDist(xnew1(i,j),xnew1(i,j+1));
        end
        dist=dist+cityDist(xnew1(i,1),xnew1(i,n));
        if indiFit(i)>dist
            individual(i,:)=xnew1(i,:);
        end
    end
    
    [value,index]=min(indiFit);
    L_best(N)=indiFit(index);
    tourGbest=individual(index,:);
    
end

%% �����ͼ
figure
plot(L_best)
title('�㷨ѵ������')
xlabel('��������')
ylabel('��Ӧ��ֵ')
grid on


figure
hold on
plot([cityCoor(tourGbest(1),1),cityCoor(tourGbest(n),1)],[cityCoor(tourGbest(1),2),...
    cityCoor(tourGbest(n),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g')
hold on
for i=2:n
    plot([cityCoor(tourGbest(i-1),1),cityCoor(tourGbest(i),1)],[cityCoor(tourGbest(i-1),2),...
        cityCoor(tourGbest(i),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g')
    hold on
end
legend('�滮·��')
scatter(cityCoor(:,1),cityCoor(:,2));
title('�滮·��','fontsize',10)
xlabel('km','fontsize',10)
ylabel('km','fontsize',10)
grid on