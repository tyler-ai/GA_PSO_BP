clear
clc
%% ��������
% citys = [565,575;25,185;345,750;945,685;845,655;880,660;25,230;525,1000;
%     580,1175;650,1130;1605,620;1220,580;1465,200;1530,5;845,680;725,370;
%     145,665;415,635;510,875;560,365;300,465;520,585;480,415;835,625;
%     975,580;1215,245;1320,315;1250,400;660,180;410,250;420,555;575,665;
%     1150,1160;700,580;685,595;685,610;770,610;795,645;720,635;760,650;
%     475,960;95,260;875,920;700,500;555,815;830,485;1170,65;830,610;
%     605,625;595,360;1340,725;1740,245];
city_num = 30;%��������
citys = ceil(100 * rand(city_num,2));%������ɳ�������
%% ������м��໥����
n = size(citys,1);
D = zeros(n,n);
for i = 1:n
    for j = 1:n
        if i ~= j
            D(i,j) = sqrt(sum((citys(i,:) - citys(j,:)).^2));
        else
            D(i,j) = 1e-4;      
        end
    end    
end

figure
r_Route = randperm(n);
plot([citys(r_Route,1);citys(r_Route(1),1)],...
     [citys(r_Route,2);citys(r_Route(1),2)],'o-');
grid on
for i = 1:size(citys,1)
    text(citys(i,1),citys(i,2),['   ' num2str(i)]);
end
text(citys(r_Route(1),1),citys(r_Route(1),2),'       ���');
text(citys(r_Route(end),1),citys(r_Route(end),2),'       �յ�');
xlabel('����λ�ú�����')
ylabel('����λ��������')
title(['��Ⱥ�㷨��ʼ��·��'])


%% ��ʼ������
m = 50;                              % ��������
alpha = 1;                           % ��Ϣ����Ҫ�̶�����
beta = 5;                            % ����������Ҫ�̶�����
rho = 0.1;                           % ��Ϣ�ػӷ�����
Q = 1;                               % ��ϵ��
Eta = 1./D;                          % ��������
Tau = ones(n,n);                     % ��Ϣ�ؾ���
Table = zeros(m,n);                  % ·����¼��
iter = 1;                            % ����������ֵ
iter_max = 200;                      % ���������� 
Route_best = zeros(iter_max,n);      % �������·��       
Length_best = zeros(iter_max,1);     % �������·���ĳ���  
Length_ave = zeros(iter_max,1);      % ����·����ƽ������  

%% ����Ѱ�����·��
while iter <= iter_max
    % ��������������ϵ�������
      start = zeros(m,1);
      for i = 1:m
          temp = randperm(n);
          start(i) = temp(1);
      end
      Table(:,1) = start; 
      % ������ռ�
      citys_index = 1:n;
      % �������·��ѡ��
      for i = 1:m
          % �������·��ѡ��
         for j = 2:n
             tabu = Table(i,1:(j - 1));           % �ѷ��ʵĳ��м���(���ɱ�)
             allow_index = ~ismember(citys_index,tabu);
             allow = citys_index(allow_index);  % �����ʵĳ��м���
             P = allow;
             % ������м�ת�Ƹ���
             for k = 1:length(allow)
                 P(k) = Tau(tabu(end),allow(k))^alpha * Eta(tabu(end),allow(k))^beta;
             end
             P = P/sum(P);
             % ���̶ķ�ѡ����һ�����ʳ���
             Pc = cumsum(P);     
            target_index = find(Pc >= rand); 
            target = allow(target_index(1));
            Table(i,j) = target;
         end
      end
      % ����������ϵ�·������
      Length = zeros(m,1);
      for i = 1:m
          Route = Table(i,:);
          for j = 1:(n - 1)
              Length(i) = Length(i) + D(Route(j),Route(j + 1));
          end
          Length(i) = Length(i) + D(Route(n),Route(1));
      end
      % �������·�����뼰ƽ������
      if iter == 1
          [min_Length,min_index] = min(Length);
          Length_best(iter) = min_Length;  
          Length_ave(iter) = mean(Length);
          Route_best(iter,:) = Table(min_index,:);
      else
          [min_Length,min_index] = min(Length);
          Length_best(iter) = min(Length_best(iter - 1),min_Length);
          Length_ave(iter) = mean(Length);
          if Length_best(iter) == min_Length
              Route_best(iter,:) = Table(min_index,:);
          else
              Route_best(iter,:) = Route_best((iter-1),:);
          end
      end
      % ������Ϣ��
      Delta_Tau = zeros(n,n);
      % ������ϼ���
      for i = 1:m
          % ������м���
          for j = 1:(n - 1)
              Delta_Tau(Table(i,j),Table(i,j+1)) = Delta_Tau(Table(i,j),Table(i,j+1)) + Q/Length(i);
          end
          Delta_Tau(Table(i,n),Table(i,1)) = Delta_Tau(Table(i,n),Table(i,1)) + Q/Length(i);
      end
      Tau = (1-rho) * Tau + Delta_Tau;
    % ����������1�����·����¼��
    fprintf('��%d��������·������Ϊ��%1.10f\n\n',iter,Length_best(iter))
    iter = iter + 1;
    Table = zeros(m,n);
end

%% �����ʾ
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
disp(['��̾���:' num2str(Shortest_Length)]);
disp(['���·��:' num2str([Shortest_Route Shortest_Route(1)])]);

%% ��ͼ
figure
plot([citys(Shortest_Route,1);citys(Shortest_Route(1),1)],...
     [citys(Shortest_Route,2);citys(Shortest_Route(1),2)],'o-','LineWidth',2);
grid on
for i = 1:size(citys,1)
    text(citys(i,1),citys(i,2),['   ' num2str(i)]);
end
text(citys(Shortest_Route(1),1),citys(Shortest_Route(1),2),'       ���');
text(citys(Shortest_Route(end),1),citys(Shortest_Route(end),2),'       �յ�');
xlabel('����λ�ú�����')
ylabel('����λ��������')
title(['��Ⱥ�㷨�Ż�·��(��̾���:' num2str(Shortest_Length) ')'])
figure
plot(1:iter_max,Length_best,'b',1:iter_max,Length_ave,'r:','LineWidth',2)
legend('��̾���','ƽ������')
xlabel('��������')
ylabel('����')
title('������̾�����ƽ������Ա�')

