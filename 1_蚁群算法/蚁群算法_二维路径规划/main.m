%% ��ջ���
clc;clear

%% �ϰ�������
position = load('barrier.txt');
plot([0,200],[0,200],'.');
hold on
B = load('barrier.txt');
xlabel('km','fontsize',12)
ylabel('km','fontsize',12)
title('��ά�滮�ռ�','fontsize',12)
%% ���������յ�
S = [20,180];
T = [160,90];
plot([S(1),T(1)],[S(2),T(2)],'.');

% ͼ�α�ע
text(S(1)+2,S(2),'S');
text(T(1)+2,T(2),'T');
 
%% ����ϰ���ͼ��
fill(position(1:4,1),position(1:4,2),[0,0,0]);
fill(position(5:8,1),position(5:8,2),[0,0,0]);
fill(position(9:12,1),position(9:12,2),[0,0,0]);
fill(position(13:15,1),position(13:15,2),[0,0,0]);

% ������·�˵�����
L = load('lines.txt');
 
%% ����߼��е�
v = zeros(size(L));
for i=1:20
    plot([position(L(i,1),1),position(L(i,2),1)],[position(L(i,1),2)...
        ,position(L(i,2),2)],'color','black','LineStyle','--');
    v(i,:) = (position(L(i,1),:)+position(L(i,2),:))/2;
    plot(v(i,1),v(i,2),'*');
    text(v(i,1)+2,v(i,2),strcat('v',num2str(i)));
end
 
%% ������·��
sign = load('matrix.txt');
[n,m]=size(sign);
 
for i=1:n
    
    if i == 1
        for k=1:m-1
            if sign(i,k) == 1
                plot([S(1),v(k-1,1)],[S(2),v(k-1,2)],'color',...
                    'black','Linewidth',2,'LineStyle','-');
            end
        end
        continue;
    end
    
    for j=2:i
        if i == m
            if sign(i,j) == 1
                plot([T(1),v(j-1,1)],[T(2),v(j-1,2)],'color',...
                    'black','Linewidth',2,'LineStyle','-');
            end
        else
            if sign(i,j) == 1
                plot([v(i-1,1),v(j-1,1)],[v(i-1,2),v(j-1,2)],...
                    'color','black','Linewidth',2,'LineStyle','-');
            end
        end
    end
end
path = DijkstraPlan(position,sign);
j = path(22);
plot([T(1),v(j-1,1)],[T(2),v(j-1,2)],'color','yellow','LineWidth',3,'LineStyle','-.');
i = path(22);
j = path(i);
count = 0;
while true
    plot([v(i-1,1),v(j-1,1)],[v(i-1,2),v(j-1,2)],'color','yellow','LineWidth',3,'LineStyle','-.');
    count = count + 1;
    i = j;
    j = path(i);
    if i == 1 || j==1
        break;
    end
end
plot([S(1),v(i-1,1)],[S(2),v(i-1,2)],'color','yellow','LineWidth',3,'LineStyle','-.');


count = count+3;
pathtemp(count) = 22;
j = 22;
for i=2:count
    pathtemp(count-i+1) = path(j);
    j = path(j);
end
path = pathtemp;
path = [1     9     8     7    13    14    12    22];

%% ��Ⱥ�㷨������ʼ��
pathCount = length(path)-2;          %�����߶�����
pheCacuPara=2;                       %��Ϣ�ؼ������
pheThres = 0.8;                      %��Ϣ��ѡ����ֵ
pheUpPara=[0.1 0.0003];              %��Ϣ�ظ��²���
qfz= zeros(pathCount,10);            %����ֵ

phePara = ones(pathCount,10)*pheUpPara(2);         %��Ϣ��
qfzPara1 = ones(10,1)*0.5;           %������Ϣ����
qfzPara2 = 1.1;                      %������Ϣ����
m=10;                                %��Ⱥ����
NC=500;                              %ѭ������
pathk = zeros(pathCount,m);          %���������¼
shortestpath = zeros(1,NC);          %�������̼�¼
 
%% ��ʼ���·��
dijpathlen = 0;
vv = zeros(22,2);
vv(1,:) = S;
vv(22,:) = T;
vv(2:21,:) = v;
for i=1:pathCount-1
dijpathlen = dijpathlen + sqrt((vv(path(i),1)-vv(path(i+1),1))^2+(vv(path(i),2)-vv(path(i+1),2))^2);
end
LL = dijpathlen;
 
%% ������������
lines = zeros(pathCount,4);
for i = 1:pathCount
    lines(i,1:2) = B(L(path(i+1)-1,1),:);
    lines(i,3:4) = B(L(path(i+1)-1,2),:);
end
 
%% ѭ������
for num = 1:NC
    
    %% ���ϵ���Ѱ��һ��
    for i=1:pathCount
        for k=1:m
            q = rand();
            qfz(i,:) = (qfzPara2-abs((1:10)'/10-qfzPara1))/qfzPara2; %������Ϣ
            if q<=pheThres%ѡ����Ϣ�����ֵ
                arg = phePara(i,:).*(qfz(i,:).^pheCacuPara);
                j = find(arg == max(arg));
                pathk(i,k) = j(1);
            else  % ���̶�ѡ��
                arg = phePara(i,:).*(qfz(i,:).^pheCacuPara);
                sumarg = sum(arg);
                qq = (q-pheThres)/(1-pheThres);
                qtemp = 0;
                j = 1;
                while qtemp < qq
                    qtemp = qtemp + (phePara(i,j)*(qfz(i,j)^pheCacuPara))/sumarg;
                    j=j+1;
                end
                j=j-1;
                pathk(i,k) = j(1);
            end
            % ��Ϣ�ظ���
            phePara(i,j) = (1-pheUpPara(1))*phePara(i,j)+pheUpPara(1)*pheUpPara(2);
        end
    end
    
    %% ����·������
    len = zeros(1,k);
    for k=1:m
        Pstart = S;
        Pend = lines(1,1:2) + (lines(1,3:4)-lines(1,1:2))*pathk(1,k)/10;
        for l=1:pathCount
            len(1,k) = len(1,k)+sqrt(sum((Pend-Pstart).^2));
            Pstart = Pend;
            if l<pathCount
                Pend = lines(l+1,1:2) + (lines(l+1,3:4)-lines(l+1,1:2))*pathk(l+1,k)/10;
            end
        end
        Pend = T;
        len(1,k) = len(1,k)+sqrt(sum((Pend-Pstart).^2));
    end
    
    %% ������Ϣ��
    % Ѱ�����·��
    minlen = min(len);
    minlen = minlen(1);
    minant = find(len == minlen);
    minant = minant(1);
    
    % ����ȫ�����·��
    if minlen < LL
        LL = minlen;
    end
    
    % ������Ϣ��
    for i=1:pathCount
        phePara(i,pathk(i,minant)) = (1-pheUpPara(1))* phePara(i,pathk(i,minant))+pheUpPara(1)*(1/minlen);
    end
    shortestpath(num) = minlen;
end

figure;
plot(1:NC,shortestpath,'color','blue');
hold on
plot(1:NC,dijpathlen,'color','red');
ylabel('·���ܳ���');
xlabel('��������');
