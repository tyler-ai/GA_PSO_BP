%% �������
% ����
%SelCh  ��ѡ��ĸ���
%Pc     �������
%�����
% SelCh �����ĸ���
function SelCh=Recombin(SelCh,Pc)
NSel=size(SelCh,1);
for i=1:2:NSel-mod(NSel,2)
    if Pc>=rand %�������Pc
        [SelCh(i,:),SelCh(i+1,:)]=intercross(SelCh(i,:),SelCh(i+1,:));
    end
end

%���룺
%a��bΪ����������ĸ���
%�����
%a��bΪ�����õ�����������

function [a,b]=intercross(a,b)
L=length(a);
r1=randsrc(1,1,[1:L]);
r2=randsrc(1,1,[1:L]);
if r1~=r2
    a0=a;b0=b;
    s=min([r1,r2]);
    e=max([r1,r2]);
    for i=s:e
        a1=a;b1=b;
        a(i)=b0(i);
        b(i)=a0(i);
        x=find(a==a(i));
        y=find(b==b(i));
        i1=x(x~=i);
        i2=y(y~=i);
        if ~isempty(i1)
            a(i1)=a1(i);
        end
        if ~isempty(i2)
            b(i2)=b1(i);
        end
    end
end



%
% %�����㷨���ò���ƥ�佻��%�����㷨���ò���ƥ�佻��
% function [a,b]=intercross(a,b)
% L=length(a);
% r1=ceil(rand*L);
% r2=ceil(rand*L);
% r1=4;r2=7;
% if r1~=r2
%     s=min([r1,r2]);
%     e=max([r1,r2]);
%     a1=a;b1=b;
%     a(s:e)=b1(s:e);
%     b(s:e)=a1(s:e);
%     for i=[setdiff(1:L,s:e)]
%         [tf, loc] = ismember(a(i),a(s:e));
%         if tf
%             a(i)=a1(loc+s-1);
%         end
%         [tf, loc]=ismember(b(i),b(s:e));
%         if tf
%             b(i)=b1(loc+s-1);
%         end
%     end
% end
