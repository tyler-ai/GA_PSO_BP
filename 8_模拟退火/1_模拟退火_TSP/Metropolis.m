function [S,R]=Metropolis(S1,S2,D,T)
%% ����
% S1��  ��ǰ��
% S2:   �½�
% D:    ��������������е�֮��ľ��룩
% T:    ��ǰ�¶�
%% ���
% S��   ��һ����ǰ��
% R��   ��һ����ǰ���·�߾���
%%
R1=PathLength(D,S1);  %����·�߳���
N=length(S1);         %�õ����еĸ���

R2=PathLength(D,S2);  %����·�߳���
dC=R2-R1;   %��������֮��
if dC<0       %����������� ������·��
    S=S2;
    R=R2;
elseif exp(-dC/T)>=rand   %��exp(-dC/T)���ʽ�����·��
    S=S2;
    R=R2;
else        %��������·��
    S=S1;
    R=R1;
end