clear
clc

T = [1790 1800 1810 1820 1830 1840 1850 1860 1870 1880 1890 1900 1910 1920 1930 1940 1950 1960 1970 1980];
N = [323.45 341.6 360.7 381 409 412 412 377 358 368 380 400 423 472 489 518.77 551.67 662.07 825.4 987];

[x,PS_x] = mapminmax(T, 0, 1);
[y,PS_y] = mapminmax(N, 0, 1);

h = 5;%������ڵ���
l = 0.3;%ѧϰ��
max_T = 10000;%����������
Error = 0.005;%��С��ֹ���
w1 = 10*rand(h,1);%����㡪������Ȩֵ
w2 = 10*rand(1,h);%�����㡪�����Ȩֵ
yw1 = 10*rand(h,1);%��������ֵ
yw2 = 10*rand;%�������ֵ
t = cputime;
 
for i=1:max_T
    e=0;
    for b=1:length(x)
        net1=x(b)*w1-yw1;
        out1=logsig(net1);
        net2=w2*out1-yw2;
        out2(b)=net2;
        det2 =y(b) - out2(b);
        det1 = ((det2 * w2') .* out1) .*(1-out1);
        w1 = w1 + det1 * x(b) * l;
        w2 = w2 + (det2 * out1)' * l;
        yw1 = -det1 * l + yw1;
        yw2 = -det2 * l + yw2;
        ei=(out2(b)-y(b))^2;
        e=ei+e;%�ۼ����
    end
    Err(i)=e;
    if Err(i)<=Error%��ֹѵ������
        break;
    end
    fprintf('��%d��ѵ�������Ϊ%f����ʱ%fs\n\n',i,Err(i),cputime-t);
end
N2=mapminmax('reverse',out2,PS_y);

%Ԥ������
year=[1990 2000 2010 2020 2030 2040 2050];
num=[1135.18 1264.10 1314 1500 NaN NaN NaN];
u=mapminmax('apply',year,PS_x);

%����Ԥ���������ֵ
for i=1:length(u)
    test_net1=u(i)*w1-yw1;
    test_out1=logsig(test_net1);
    test_net2=w2*test_out1-yw2;
    test_out2(i)=test_net2;
end
num2=mapminmax('reverse',test_out2,PS_y);

subplot(3,2,[1 2])
%comet(Err)
plot(Err,'r')
title('��������������')

subplot(323)
plot(T,N,'k-s')
hold on
plot(T,N2,'r*-')
grid on
title('ѵ���������Ч��ͼ')
legend('��ʵֵ','�ƽ�ֵ')

subplot(324)
plot(year,num,'k-s')
hold on
plot(year,num2,'r*-')
grid on
title('Ԥ���������Ч��ͼ')
legend('��ʵֵ','Ԥ��ֵ')

subplot(325)
stem(T,N-N2,'b')
title('ѵ�������������ͼ')

subplot(326)
stem(year,num-num2,'b')
title('Ԥ�������������ͼ')

figure
plot(T,N,'-*' ,'LineWidth',1.5)
hold on
plot(year,num,'-p' ,'LineWidth',1.5)
plot(T,N2,'-o' ,'LineWidth',1.5)
plot(year,num2,'-s' ,'LineWidth',1.5)
xlabel('���')
ylabel('�˿�(*10^6)')
legend('1790-1980ʵ���˿�','1990-2020ʵ���˿�','BP����˿�','BPԤ���˿�')


