 clear
clc
%�ֲ�ͼ
n = 1
for r = 0:0.01:4%��Ȼ������
    xn = 0.5;%��ʼ��Ⱥ����
    for i = 1:200
        xn = r * xn * (1 - xn);
        if i>190
            plot(r,xn,'b.')
            hold on;
        end
        n = n + 1
    end
    pause(0.0000001)%��̬��ʾ
end
title('���ģ�ͷֲ�ͼ')


