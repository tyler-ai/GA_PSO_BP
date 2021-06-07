function indiFit=fitness(x,cityCoor,cityDist)
%% �ú������ڼ��������Ӧ��ֵ
%x           input     ����
%cityCoor    input     ��������
%cityDist    input     ���о���
%indiFit     output    ������Ӧ��ֵ 

m=size(x,1);
n=size(cityCoor,1);
indiFit=zeros(m,1);
for i=1:m
    for j=1:n-1
        indiFit(i)=indiFit(i)+cityDist(x(i,j),x(i,j+1));
    end
    indiFit(i)=indiFit(i)+cityDist(x(i,1),x(i,n));
end