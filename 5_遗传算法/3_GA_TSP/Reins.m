 %% �ز����Ӵ�������Ⱥ
 %���룺
 %Chrom  ��������Ⱥ
 %SelCh  �Ӵ���Ⱥ
 %ObjV   ������Ӧ��
 %���
 % Chrom  ��ϸ������Ӵ���õ�������Ⱥ
function Chrom=Reins(Chrom,SelCh,ObjV)
NIND=size(Chrom,1);
NSel=size(SelCh,1);
[TobjV,index]=sort(ObjV);
Chrom=[Chrom(index(1:NIND-NSel),:);SelCh];