%plus selection
clear
clc
tic
x1 = 15.1 * rand(1,10) - 3;
x2 = 1.7 * rand(1,10) + 4.1;
X = [x1;x2];
sigma = rand(2,10);
gen = 1;
while gen < 100
    lamda = 1;
    while lamda <= 20
        pos=1+fix(rand(1,2)*9);
        pa1=X(:,pos(1));
        pa2=X(:,pos(2));
        if rand()<0.5
            o(1)=pa1(1);
        else
            o(1)=pa2(1);
        end
        if rand()<0.5
            o(2)=pa1(2);
        else
            o(2)=pa2(2);
        end
        sigma1=0.5*(sigma(:,pos(1))+sigma(:,pos(2)));
        Y=o'+sigma1.*randn(2,1);
        if Y(1)>=-3 & Y(1)<=12.1 & Y(2)>=4.1 & Y(2)<=5.8
            offspring(:,lamda)=Y;
            lamda=lamda+1;
        end
    end
    U=[X,offspring];
    [m,n] = size(U);
    for i=1:n
        eva(i)=f(U(:,i));
    end
    [m_eval,Ind1]=sort(eva);
    gen=gen+1
    Ind_end=Ind1(21:end);
    X=U(:,Ind_end);
    [fit(gen),Ind2]=max(eva);
end
plot(fit)
max_V = fit(gen)
opex = X(:,Ind2)
toc