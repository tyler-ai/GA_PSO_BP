function Fitness=Object_Function(rule_table,membership_function_positive,membership_function_negative);
global num
global den
global Samping_time
global Sys_time
global kp
global ki
global kd
global Expected_Value

y=zeros(1,Sys_time);
u=zeros(1,Sys_time);
er=zeros(1,Sys_time);
r=zeros(1,Sys_time);
e1=0;e2=0;E1=0;
y1=0;y2=0;y3=0;
u1=0;u2=0;u3=0;
e=zeros(1,Sys_time);
E=zeros(1,Sys_time);

for k=1:Sys_time
    r(k)=Expected_Value;
    y(k)=-den(2)*y1-den(3)*y2-den(4)*y3+num(2)*u1+num(3)*u2+num(4)*u3;
    y3=y2;y2=y1;y1=y(k);
    u3=u2;u2=u1;
    e(k)=r(k)-y(k);
    er(k)=(e(k)-e1)/Samping_time;
    Delta_e=Fuzzy_Rule(rule_table,membership_function_positive,membership_function_negative,e(k),er(k));
    E(k)=e(k)+Delta_e;
    u(k)=kp*E(k)+ki*sum(E)+kd*(E(k)-E1);
    E1=E(k);
    u1=u(k);
    e2=e1;
    e1=e(k);
end

for k=1:Sys_time
    if abs(y(k)-r(k))<=0.1
        T_r=k*Samping_time; %上升时间
        break
    else
        T_r=10000000000;
    end
end
% figure(1)
% plot(y)
% hold on
% pause(0.1)

Sum_e=sum(abs(e));%累计误差
Max_y=max(y);
OverShoot=(Max_y-r(k))*100;

Fitness=10000/(0.6*T_r+1.2*Sum_e+1.2*OverShoot);

