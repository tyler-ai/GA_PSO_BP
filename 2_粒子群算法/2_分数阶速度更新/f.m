function y = f( x )
% X=[1,3,4,5,6,7,8,9,10]; 
% Y=[10,5,4,2,1,1,2,3,4];
% Y1=x(1)*X.^2+x(2)*X+x(3);
t=1:15;
Y=[352	211	197	160	142	106	104	60	56	38	36	32	21	19	15];
Y1=x(1)*exp(x(2).*t);
y=norm(Y-Y1);
end

