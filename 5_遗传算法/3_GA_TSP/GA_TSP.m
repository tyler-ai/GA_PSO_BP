clear
clc
close all
load('CityPosition3.mat');%�����������λ��,���Ի���load CityPosition1~3.mat
NIND=100;       %��Ⱥ��С
MAXGEN=300;     %��������
Pc=0.9;         %�������
Pm=0.1;         %�������
GGAP=0.9;       %����(Generation gap)
D=Distanse(X);  %���ɾ������
N=size(D,1);    %(34*34)
%% ��ʼ����Ⱥ
Chrom=InitPop(NIND,N);
% �ڶ�άͼ�ϻ������������
figure
plot(X(:,1),X(:,2),'o');
%% ����������·��ͼ
figure
DrawPath(Chrom(1,:),X)
%% ���������·�ߺ��ܾ���
disp('��ʼ��Ⱥ�е�һ�����ֵ:')
OutputPath(Chrom(1,:));
Rlength=PathLength(D,Chrom(1,:));
disp(['�ܾ��룺',num2str(Rlength)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
%% �Ż�
gen=1;
ObjV=PathLength(D,Chrom);  %����·�߳���
preObjV=min(ObjV);
while gen<MAXGEN
    %% ������Ӧ��
    ObjV=PathLength(D,Chrom);  %����·�߳���
    preObjV(gen)=min(ObjV);
    fprintf('��%d��������·������Ϊ��%1.10f\n',gen,preObjV(gen))
    FitnV=Fitness(ObjV);
    SelCh=Select(Chrom,FitnV,GGAP);% ѡ��
    SelCh=Recombin(SelCh,Pc);% �������
    SelCh=Mutate(SelCh,Pm);% ����
    SelCh=Reverse(SelCh,D);% ��ת����
    Chrom=Reins(Chrom,SelCh,ObjV);% �ز����Ӵ�������Ⱥ
    gen=gen+1; % ���µ�������
end

%% �������Ž��·��ͼ
figure
ObjV=PathLength(D,Chrom);  %����·�߳���
[minObjV,minInd]=min(ObjV);
DrawPath(Chrom(minInd(1),:),X)
%% ������������
figure
plot(preObjV)
title('�Ż�����')
xlabel('����')
ylabel('����ֵ')
%% ������Ž��·�ߺ��ܾ���
disp('���Ž�:')
p=OutputPath(Chrom(minInd(1),:));
disp(['�ܾ��룺',num2str(ObjV(minInd(1)))]);
disp('-------------------------------------------------------------')
