clear
clc
x0 = 2;
y0 = 1;
z0 = 10;
t = 0.03;
a = 10;
b = 28;
c = 8/3;
x = [];y = [];z = [];
for i = 1:3000
    i
    x0 = t * a *(y0 - x0) + x0;
    y0 = t * (x0 * (b - z0) - y0) + y0;
    z0 = t * (x0 * y0 - c * z0) + z0;
    x = [x,x0];y = [y,y0];z = [z,z0];
    plot3(x(end),y(end),z(end),'rp',x,y,z ,'LineWidth',0.5)
    grid on
    pause(0.00001)
end
figure
plot3(x,y,z ,'LineWidth',0.5);grid on
title('ÂåÂ××ÈÇúÏß')