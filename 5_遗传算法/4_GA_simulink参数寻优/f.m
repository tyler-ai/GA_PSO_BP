function Fitness = f(x)
%x = [1,220,0.001];
global kp ki kd
kp1 = x(1);
ki1 = x(2);
kd1 = x(3);
sim_time = 5;
sim_step = 1000;

for i=1:sim_step %生成时间戳
    time_stamp(i,1) = i * sim_time / sim_step;
end

%生成序列
kp = [time_stamp,ones(sim_step,1)*kp1];
ki = [time_stamp,ones(sim_step,1)*ki1];
kd = [time_stamp,ones(sim_step,1)*kd1];

try
    sim('pid3.slx',[0,5]);%运行仿真simulink模型
    y = Data_out.Data;%得到仿真曲线
    Time = Data_out.Time;%得到时间
    Ind = find(abs(y - 1) <= 0.1);
    T_r = Time(Ind(1)); %上升时间
    
    OverShoot=abs((max(y)-1)*100);%超调量
    E = abs(y(end)-1);%稳态误差
    Fitness = 1/( T_r + OverShoot + E);%求最大值，取倒数
catch
    Fitness = 0;
    return
end
end