function Fitness = f(x)
x1 = x(1);
x2 = x(2);
x3 = x(3);
Fitness = sin(x1*pi)+x2.^2+exp(x3);
end