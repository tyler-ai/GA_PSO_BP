clc
clear
%% ���ݳ�ʼ��
%��������
load  HeightData
%HeightData = xlsread('data.xlsx');
%���񻮷�
LevelGrid=10;
PortGrid=21;

%����յ������
starty=10;starth=4;
endy=8;endh=5;
m=1;
%�㷨����
PopNumber=10;         %��Ⱥ����
BestFitness=[];    %��Ѹ���

%��ʼ��Ϣ��
pheromone=ones(21,21,21);

%% ��ʼ����·��
[path,pheromone]=searchpath(PopNumber,LevelGrid,PortGrid,pheromone, ...
    HeightData,starty,starth,endy,endh);
fitness=CacuFit(path);                          %��Ӧ�ȼ���
[bestfitness,bestindex]=min(fitness);           %�����Ӧ��
bestpath=path(bestindex,:);                     %���·��
BestFitness=[BestFitness;bestfitness];          %��Ӧ��ֵ��¼

%% ��Ϣ�ظ���
rou=0.2;
cfit=100/bestfitness;
for i=2:PortGrid-1
    pheromone(i,bestpath(i*2-1),bestpath(i*2))= ...
        (1-rou)*pheromone(i,bestpath(i*2-1),bestpath(i*2))+rou*cfit;
end

%% ѭ��Ѱ������·��
for k=1:200
    k
    %% ·������
    [path,pheromone]=searchpath(PopNumber,LevelGrid,PortGrid,...
        pheromone,HeightData,starty,starth,endy,endh);
    
    %% ��Ӧ��ֵ�������
    fitness=CacuFit(path);
    [newbestfitness,newbestindex]=min(fitness);
    if newbestfitness<bestfitness
        bestfitness=newbestfitness;
        bestpath=path(newbestindex,:);
    end
    BestFitness(k)=bestfitness;
    
    %% ������Ϣ��
    cfit=100/bestfitness;
    for i=2:PortGrid-1
        pheromone(i,bestpath(i*2-1),bestpath(i*2))=(1-rou)* ...
            pheromone(i,bestpath(i*2-1),bestpath(i*2))+rou*cfit;
    end
end

%% ���·��
for i=1:21
    a(i,1)=bestpath(i*2-1);
    a(i,2)=bestpath(i*2);
end
figure(1)
x=1:21;
y=1:21;
[x1,y1]=meshgrid(x,y);
mesh(x1,y1,HeightData)
axis([1,21,1,21,0,2000])
hold on
k=1:21;
plot3(k(1)',a(1,1)',a(1,2)'*200,'--o','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',10)
plot3(k(21)',a(21,1)',a(21,2)'*200,'--o','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',10)
text(k(1)',a(1,1)',a(1,2)'*200,'S');
text(k(21)',a(21,1)',a(21,2)'*200,'T');
xlabel('km','fontsize',12);
ylabel('km','fontsize',12);
zlabel('m','fontsize',12);
title('��ά·���滮�ռ�','fontsize',12)
set(gcf, 'Renderer', 'ZBuffer')
hold on
plot3(k',a(:,1)',a(:,2)'*200,'--o')

%% ��Ӧ�ȱ仯
figure(2)
plot(BestFitness)
title('��Ѹ�����Ӧ�ȱ仯����')
xlabel('��������')
ylabel('��Ӧ��ֵ')
