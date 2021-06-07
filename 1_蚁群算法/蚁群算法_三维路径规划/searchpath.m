function [path,pheromone]=searchpath(PopNumber,LevelGrid,PortGrid,pheromone,HeightData,starty,starth,endy,endh)
%% �ú�������������Ⱥ�㷨��·���滮
%LevelGrid     input    ���򻮷ָ���
%PortGrid      input    ���򻮷ָ���
%pheromone     input    ��Ϣ��
%HeightData    input    ��ͼ�߶�
%starty starth input    ��ʼ��
%path          output   �滮·��
%pheromone     output   ��Ϣ��

%% ��������
ycMax=2;   %���Ϻ������䶯
hcMax=2;   %�����������䶯
decr=0.9;  %��Ϣ��˥������

%% ѭ������·��
for ii=1:PopNumber
    
    path(ii,1:2)=[starty,starth];  %��¼·��
    NowPoint=[starty,starth];      %��ǰ�����
    
    %% �������Ӧ��ֵ
    for abscissa=2:PortGrid-1
        %�����������ݵ��Ӧ����Ӧ��ֵ
        kk=1;
        for i=-ycMax:ycMax
            for j=-hcMax:hcMax
                NextPoint(kk,:)=[NowPoint(1)+i,NowPoint(2)+j];
                if (NextPoint(kk,1)<20)&&(NextPoint(kk,1)>0)&&(NextPoint(kk,2)<20)&&(NextPoint(kk,2)>0)
                    qfz(kk)=CacuQfz(NextPoint(kk,1),NextPoint(kk,2),NowPoint(1),NowPoint(2),endy,endh,abscissa,HeightData);
                    qz(kk)=qfz(kk)*pheromone(abscissa,NextPoint(kk,1),NextPoint(kk,2));
                    kk=kk+1;
                else
                    qz(kk)=0;
                    kk=kk+1;
                end
            end
        end
        
        
        %ѡ���¸���
        sumq=qz./sum(qz);
    
        pick=rand;
        while pick==0
            pick=rand;
        end
        
        for i=1:25
            pick=pick-sumq(i);
            if pick<=0
                index=i;
                break;
            end
        end
        
        oldpoint=NextPoint(index,:);
        
        %������Ϣ��
        pheromone(abscissa+1,oldpoint(1),oldpoint(2))=0.5*pheromone(abscissa+1,oldpoint(1),oldpoint(2));
        
        %·������
        path(ii,abscissa*2-1:abscissa*2)=[oldpoint(1),oldpoint(2)];    
        NowPoint=oldpoint;
        
    end
    path(ii,41:42)=[endy,endh];
end
    
    