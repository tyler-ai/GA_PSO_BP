clear
clc
size_G=30;
G=fix(randn(size_G,size_G));
MM=size(G,1); % G ����ͼΪ 01 �������Ϊ 1 ��ʾ�ϰ���
Tau=ones(MM*MM,MM*MM);% Tau ��ʼ��Ϣ�ؾ�����Ϊǰ�����ʳ����в�������Ϣ�أ�
Tau=8.*Tau;
K=50; % K ����������ָ���ϳ������ٲ���
M=10; % M ���ϸ�����ÿһ�������ж��ٸ���
S=1 ; % S ��ʼ�㣨���·������ʼ�㣩
E=MM*MM; % E ��ֹ�㣨���·����Ŀ�ĵ㣩
G(S)=0;
G(E)=0;
Alpha=1; % Alpha ������Ϣ����Ҫ�̶ȵĲ���
Beta=7; % Beta ��������ʽ������Ҫ�̶ȵĲ���
Rho=0.3 ; % Rho ��Ϣ������ϵ��
Q=1; % Q ��Ϣ������ǿ��ϵ��
minkl=inf;
mink=0;
minl=0;
D=G2D(G);
N=size(D,1);%N ��ʾ����Ĺ�ģ�����ظ�����
a=1;%С�������صı߳�
Ex=a*(mod(E,MM)-0.5);% ��ֹ�������
if Ex==-0.5
    Ex=MM-0.5;
end
Ey=a*(MM+0.5-ceil(E/MM));% ��ֹ��������
Eta=zeros(N);% ����ʽ��Ϣ��ȡΪ��Ŀ����ֱ�߾���ĵ���
%���湹������ʽ��Ϣ����
for i=1:N
    ix=a*(mod(i,MM)-0.5);
    if ix==-0.5
        ix=MM-0.5;
    end
    iy=a*(MM+0.5-ceil(i/MM));
    if i~=E
        Eta(i)=1/((ix-Ex)^2+(iy-Ey)^2)^0.5;
    else
        Eta(i)=100;
    end
end
ROUTES=cell(K,M);% ��ϸ���ṹ�洢ÿһ����ÿһֻ���ϵ�����·��
PL=zeros(K,M);% �þ���洢ÿһ����ÿһֻ���ϵ�����·�߳���
%% ----------- ���� K ��������ʳ���ÿ���ɳ� M ֻ���� --------------------
for k=1:K
    k
    for m=1:M
        %% ��һ����״̬��ʼ��
        W=S;% ��ǰ�ڵ��ʼ��Ϊ��ʼ��
        Path=S;%����·�߳�ʼ��
        PLkm=0;% ����·�߳��ȳ�ʼ��
        TABUkm=ones(N);% ���ɱ��ʼ��
        TABUkm(S)=0;% �Ѿ��ڳ�ʼ���ˣ����Ҫ�ų�
        DD=D;% �ڽӾ����ʼ��
        %% �ڶ�������һ������ǰ���Ľڵ�
        DW=DD(W,:);
        DW1=find(DW);
        for j=1:length(DW1)
            if TABUkm(DW1(j))==0
                DW(DW1(j))=0;
            end
        end
        LJD=find(DW);
        Len_LJD=length(LJD);% ��ѡ�ڵ�ĸ���
        %% ��ʳֹͣ����������δ����ʳ�������������ͬ
        while W~=E&&Len_LJD>=1
            %% ��������ת�ֶķ�ѡ����һ����ô��
            PP=zeros(Len_LJD);
            for i=1:Len_LJD
                PP(i)=(Tau(W,LJD(i))^Alpha)*((Eta(LJD(i)))^Beta);
            end
            sumpp=sum(PP);
            PP=PP/sumpp;%�������ʷֲ�
            Pcum(1)=PP(1);
            for i=2:Len_LJD
                Pcum(i)=Pcum(i-1)+PP(i);
            end
            Select=find(Pcum>=rand);
            to_visit=LJD(Select(1));
            %% ���Ĳ���״̬���ºͼ�¼
            Path=[Path,to_visit];% ·������
            PLkm=PLkm+DD(W,to_visit);% ·����������
            W=to_visit;% �����Ƶ���һ���ڵ�
            for kk=1:N
                if TABUkm(kk)==0
                    DD(W,kk)=0;
                    DD(kk,W)=0;
                end
            end
            TABUkm(W)=0;% �ѷ��ʹ��Ľڵ�ӽ��ɱ���ɾ��
            DW=DD(W,:);
            DW1=find(DW);
            for j=1:length(DW1)
                if TABUkm(DW1(j))==0
                    DW(j)=0;
                end
            end
            LJD=find(DW);
            Len_LJD=length(LJD);% ��ѡ�ڵ�ĸ���
        end
        %% ���岽������ÿһ��ÿһֻ���ϵ���ʳ·�ߺ�·�߳���
        ROUTES{k,m}=Path;
        if Path(end)==E
            PL(k,m)=PLkm;
            if PLkm<minkl
                mink=k;minl=m;minkl=PLkm;
            end
        else
            PL(k,m)=0;
        end
        best_PLkm(k)=minkl;
    end
    %% ��������������Ϣ��
    Delta_Tau=zeros(N,N);% ��������ʼ��
    for m=1:M
        if PL(k,m)
            ROUT=ROUTES{k,m};
            TS=length(ROUT)-1;% ����
            PL_km=PL(k,m);
            for s=1:TS
                x=ROUT(s);
                y=ROUT(s+1);
                Delta_Tau(x,y)=Delta_Tau(x,y)+Q/PL_km;
                Delta_Tau(y,x)=Delta_Tau(y,x)+Q/PL_km;
            end
        end
    end
    Tau=(1-Rho).*Tau+Delta_Tau;% ��Ϣ�ػӷ�һ���֣�������һ����
    
end



%% --------------------------- ��ͼ --------------------------------
figure(1)
plot(best_PLkm,'r','LineWidth',2)
grid on
title(' �������ߣ���С·�����ȣ� ');
xlabel(' �������� ');
ylabel(' ·������ ');
figure(2)%������ͼ
axis([0,MM,0,MM])
for i=1:MM
    for j=1:MM
        if G(i,j)==1
            x1=j-1;y1=MM-i;
            x2=j;y2=MM-i;
            x3=j;y3=MM-i+1;
            x4=j-1;y4=MM-i+1;
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],[0.1,0.1,0.1]);
            hold on
        else
            x1=j-1;y1=MM-i;
            x2=j;y2=MM-i;
            x3=j;y3=MM-i+1;
            x4=j-1;y4=MM-i+1;
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]);
            hold on
        end
    end
end
hold on
ROUT=ROUTES{mink,minl};
LENROUT=length(ROUT);
Rx=ROUT;
Ry=ROUT;
for ii=1:LENROUT
    Rx(ii)=a*(mod(ROUT(ii),MM)-0.5);
    if Rx(ii)==-0.5
        Rx(ii)=MM-0.5;
    end
    Ry(ii)=a*(MM+0.5-ceil(ROUT(ii)/MM));
end
plot(Rx,Ry,'g','LineWidth',5)