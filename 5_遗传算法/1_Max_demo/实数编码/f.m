function y = f(x)
if abs(x(1))>5 | abs(x(2))>5 | abs(x(1))>5 | abs(x(4))>5%������Լ��
    y = -inf;%��Ӧ��ֵΪ�������
    return;
else%���������Ӧ��ֵ
    y = 1 /(x(1)^2+x(2)^2+x(3)^2+x(4)^2+1);
end