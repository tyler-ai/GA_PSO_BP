function Fitness = f(x)
%x = [1,220,0.001];
global kp ki kd
kp1 = x(1);
ki1 = x(2);
kd1 = x(3);
sim_time = 5;
sim_step = 1000;

for i=1:sim_step %����ʱ���
    time_stamp(i,1) = i * sim_time / sim_step;
end

%��������
kp = [time_stamp,ones(sim_step,1)*kp1];
ki = [time_stamp,ones(sim_step,1)*ki1];
kd = [time_stamp,ones(sim_step,1)*kd1];

try
    sim('pid3.slx',[0,5]);%���з���simulinkģ��
    y = Data_out.Data;%�õ���������
    Time = Data_out.Time;%�õ�ʱ��
    Ind = find(abs(y - 1) <= 0.1);
    T_r = Time(Ind(1)); %����ʱ��
    
    OverShoot=abs((max(y)-1)*100);%������
    E = abs(y(end)-1);%��̬���
    Fitness = 1/( T_r + OverShoot + E);%�����ֵ��ȡ����
catch
    Fitness = 0;
    return
end
end