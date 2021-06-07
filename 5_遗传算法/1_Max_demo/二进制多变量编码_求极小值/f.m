function J = f(x)
global B v
u(1) = x(1);
u(2) = x(2);
u(3) = x(3);
u(4) = x(4);
u(5) = x(5);
u(6) = x(6);
u(7) = x(7);

J = norm(B * u' - v);
end