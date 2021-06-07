clear
clc
%两条曲线哦~
%非线性系统对初值的敏感性
%初始点差别很小，后期差别越来越大
x0 = 1;y0 = 0;z0 = 1;
x1 = 1;y1 = 0;z1 = 0.9999;
t = 0.05;

a = 10;
b = 28;
c = 8/3;

x = [];y = [];z = [];
xx = [];yy = [];zz = [];
for i = 1:10000
    i
    x0 = t * a *(y0 - x0) + x0;
    y0 = t * (x0 * (b - z0) - y0) + y0;
    z0 = t * (x0 * y0 - c * z0) + z0;
    x = [x,x0];y = [y,y0];z = [z,z0];
    
    x1 = t * a *(y1 - x1) + x1;
    y1 = t * (x1 * (b - z1) - y1) + y1;
    z1 = t * (x1 * y1 - c * z1) + z1;
    xx = [xx,x1];yy = [yy,y1];zz = [zz,z1];
    
    plot3(x(end),y(end),z(end),'rp',x,y,z,'r' ,'LineWidth',1.1)
    grid on
    hold on
    plot3(xx(end),yy(end),zz(end),'bp',xx,yy,zz,'b' ,'LineWidth',1.1)
    hold off
    pause(0.0000001)
end
figure
subplot(121)
plot3(x,y,z ,'r','LineWidth',1.5)
grid on
title('洛伦兹曲线 A')
subplot(122)
plot3(xx,yy,zz ,'b','LineWidth',1.5)
grid on
title('洛伦兹曲线 B')