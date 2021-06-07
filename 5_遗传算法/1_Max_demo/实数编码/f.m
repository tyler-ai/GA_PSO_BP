function y = f(x)
if abs(x(1))>5 | abs(x(2))>5 | abs(x(1))>5 | abs(x(4))>5%不满足约束
    y = -inf;%适应度值为负无穷（最差）
    return;
else%否则计算适应度值
    y = 1 /(x(1)^2+x(2)^2+x(3)^2+x(4)^2+1);
end