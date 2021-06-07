clear
clc

% ��ʼ��ģ������ϵͳ����
global num
global den
global Samping_time
global Sys_time
global kp
global ki
global kd
global Expected_Value

Samping_time=0.3;%����ʱ��
kp=0.2;
ki=0.002;
kd=10;%PID����
Sys_time=100;%ϵͳ���д���

Expected_Value=3.194;%ϵͳ����ֵ

num=1;%ϵͳ����
den=conv(conv([1,0.1],[1,0.2]),[1,0.7]);
G=tf(num,den);
Z=c2d(G,Samping_time,'zoh');%��ɢ��
[num,den]=tfdata(Z,'v');
linguistic_values_num=3;%����ֵ����

% ��ʼ���Ŵ��㷨����
N=30;%��Ⱥ����
T_max=30;%����������
pc=0.8;%�������
pm=0.1;%�������
L=linguistic_values_num^2+linguistic_values_num*2;%�볤
Rule_Table=randi([1,linguistic_values_num],[N,linguistic_values_num^2]); %ģ�������
Membership_Function_Positive=rand(N,linguistic_values_num); %�����Ⱥ������Ĳ���
Membership_Function_Negative=-1*rand(N,linguistic_values_num); %�����Ⱥ������Ĳ���
rule_table=zeros(1,linguistic_values_num^2);
membership_function_positive=zeros(1,linguistic_values_num);
membership_function_negative=zeros(1,linguistic_values_num);
S=[Rule_Table,Membership_Function_Positive,Membership_Function_Negative];%��ʼ����Ⱥ
Max_f=0;%Ŀ�꺯�����ֵ

% ��һ��ѡ��
for i=1:N
    rule_table(i,:)=S(i,1:linguistic_values_num^2);
    membership_function_positive(i,:)=S(i,linguistic_values_num^2+1:linguistic_values_num^2+3);
    membership_function_negative(i,:)=S(i,linguistic_values_num^2+4:end);
    fprintf('��1��ѡ�񣬼����%d��������Ӧ����......',i);
    Fitness(i)=Object_Function(rule_table(i,:),membership_function_positive(i,:),membership_function_negative(i,:));
    fprintf('��Ӧ��ֵΪ��%f\n',Fitness(i));
    if Fitness(i)>Max_f
        Max_f=Fitness(i);
        opm_rule_table=rule_table(i,:);
        opm_membership_function_positive=membership_function_positive(i,:);
        opm_membership_function_negative=membership_function_negative(i,:);
    end
end

% ��ʼ����
t=cputime;
for T=1:T_max
    % ѡ��
    p=Fitness/sum(Fitness);
    q=cumsum(p);
    for i=1:N
        temp=rand(1);
        Ind=find(q>=temp);
        S2(i,:)=S(Ind(1),:);
    end
    % ����
    for i=1:N
        if rand(1)<pc
            I=randi([1,N]);
            J=randi([1,N]);
            if I~=J
                k1=randi([1,L]);
                k2=randi([1,L]);
                if k1>k2 || k1==k2%���㽻��
                    temp = S2(I,k1+1:end);
                    S2(I,k1+1:end)= S2(J,k1+1:end);
                    S2(J,k1+1:end)= temp;
                else%˫�㽻��
                    temp = S2(I,k1+1:k2);
                    S2(I,k1+1:k2)= S2(J,k1+1:k2);
                    S2(J,k1+1:k2)= temp;
                end
            end
        end
    end
    % ����
    for i=1:N
        if rand(1)<pm
            I=randi([1,N]);
            k1=randi([1,linguistic_values_num^2]);
            k2=randi([linguistic_values_num^2+1,linguistic_values_num^2+3]);
            k3=randi([linguistic_values_num^2+4,linguistic_values_num^2+6]);
            S2(I,k1)=randi([1,linguistic_values_num]);
            S2(I,k2)=rand();
            S2(I,k3)=-rand();
        end
    end
    
    % ����
    S=S2;
    for i=1:N
        rule_table(i,:)=S(i,1:linguistic_values_num^2);
        membership_function_positive(i,:)=S(i,linguistic_values_num^2+1:linguistic_values_num^2+3);
        membership_function_negative(i,:)=S(i,linguistic_values_num^2+4:end);
        fprintf('�����%d����%d��������Ӧ����......',T,i);
        Fitness(i)=Object_Function(rule_table(i,:),membership_function_positive(i,:),membership_function_negative(i,:));
        fprintf('��Ӧ��ֵΪ��%f\n',Fitness(i));
        if Fitness(i)>Max_f
            Max_f=Fitness(i);%�����Ӧ��
            opm_rule_table=rule_table(i,:);%���ģ�����Ʊ�
            opm_membership_function_positive=membership_function_positive(i,:);%���ap,bp,cp
            opm_membership_function_negative=membership_function_negative(i,:);%���an,bn,cn
        end
    end
    
    max_f(T)=Max_f;%�����Ӧ��
    mean_f(T)=mean(Fitness);%��Ⱥƽ����Ӧ��
    
    y=zeros(1,Sys_time);
    u=zeros(1,Sys_time);
    er=zeros(1,Sys_time);
    yr=zeros(1,Sys_time);
    e1=0;e2=0;E1=0;
    y1=0;y2=0;y3=0;
    u1=0;u2=0;u3=0;
    e=zeros(1,Sys_time);
    E=zeros(1,Sys_time);
    for j =1:Sys_time
        time(j)=j*Samping_time;%ʱ�����
        r(j)=Expected_Value;%����ֵ
        y(j)=-den(2)*y1-den(3)*y2-den(4)*y3+num(2)*u1+num(3)*u2+num(4)*u3;
        e(j)=r(j)-y(j);
        er(j)=(e(j)-e1)/Samping_time;
        y3=y2;y2=y1;y1=y(j);
        u3=u2;u2=u1;
        Delta_e=Fuzzy_Rule(opm_rule_table,opm_membership_function_positive,opm_membership_function_negative,e(j),er(j));
        E(j)=e(j)+Delta_e;
        u(j)=kp*E(j)+ki*sum(E)+kd*(E(j)-E1);
        E1=E(j);
        u1=u(j);
        e2=e1;e1=e(j);
    end
    plot(time,y,'LineWidth',2)
    hold on
    pause(0.01)
    each_time=cputime-t;
    fprintf('��%d���������Ӧ��ֵΪ%d����Ⱥƽ����Ӧ��ֵΪ%d����ʱ%ds.\n',T,fix(Max_f),fix(mean_f(T)),round(each_time));
end
title('�������Ž�Ծ��Ӧ����')

figure
plot(1:T,max_f,'b',1:T,mean_f,'g')
legend('��Ⱥ�����Ӧ��ֵ','��Ⱥƽ����Ӧ��ֵ')
xlabel('��������')
ylabel('��Ӧ��ֵ')
opm_rule_table
opm_membership_function_positive
opm_membership_function_negative
