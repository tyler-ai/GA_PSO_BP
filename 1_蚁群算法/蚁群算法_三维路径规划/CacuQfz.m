function qfz=CacuQfz(Nexty,Nexth,Nowy,Nowh,endy,endh,abscissa,HeightData)
%% �ú������ڼ�����������ֵ
%Nexty Nexth    input    �¸�������
%Nowy Nowh      input    ��ǰ������
%endy endh      input    �յ�����
%abscissa       input    ������
%HeightData     input    ��ͼ�߶�
%qfz            output   ����ֵ

%% �ж��¸����Ƿ�ɴ�
if HeightData(Nexty,abscissa)<Nexth*200
    S=1;
else
    S=0;
end

%% ��������ֵ
%D����
D=50/(sqrt(1+(Nowh*0.2-Nexth*0.2)^2+(Nexty-Nowy)^2)+sqrt((21-abscissa)^2 ...
    +(endh*0.2-Nexth*0.2)^2+(endy-Nowy)^2));
%����߶�
M=30/abs(Nexth+1);
%��������ֵ
qfz=S*M*D;



    

