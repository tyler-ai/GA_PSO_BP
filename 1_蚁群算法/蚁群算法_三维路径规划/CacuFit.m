function fitness=CacuFit(path)
%% �ú������ڼ��������Ӧ��ֵ
%path       input     ·��
%fitness    input     ·��

[n,m]=size(path);
for i=1:n
    fitness(i)=0;
    for j=2:m/2
        %��Ӧ��ֵΪ���ȼӸ߶�
        fitness(i)=fitness(i)+sqrt(1+(path(i,j*2-1)-path(i,(j-1)*2-1))^2 ...
            +(path(i,j*2)-path(i,(j-1)*2))^2)+abs(path(i,j*2));
    end
end