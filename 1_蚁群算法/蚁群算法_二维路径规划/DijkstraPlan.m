function path = DijkstraPlan(position,sign)
%% ����Dijkstra�㷨��·���滮�㷨
%position    input     %�ڵ�λ��
%sign        input     %�ڵ���Ƿ�ɴ�
 
%path        output    %�滮·��
 
%% ����·������
cost = ones(size(sign))*10000;
[n,m] = size(sign);
for i = 1:n
    for j = 1:m
        if sign(i,j) == 1
            cost(i,j) = sqrt(sum((position(i,:)-position(j,:)).^2));
        end
    end
end
 
%% ·����ʼ��
dist = cost(1,:);             %�ڵ��·������           
s = zeros(size(dist));        %�ڵ㾭����־
s(1) = 1;dist(1) = 0;
path = zeros(size(dist));     %���ξ����Ľڵ�
path(1,:) = 1;
 
%% ѭ��Ѱ��·����
for num = 2:n   
    
    % ѡ��·��������С��
    mindist = 10000;
    for i = 1:length(dist)
        if s(i) == 0
            if dist(i)< mindist
                mindist = dist(i);
                u = i;
            end
        end
    end
    
    % ���µ���·��
    s(u) = 1;
    for w = 1:length(dist)
        if s(i) == 0
            if dist(u)+cost(u,w) < dist(w)
                dist(w) = dist(u)+cost(u,w);
                path(w) = u;
            end
        end
    end
end
