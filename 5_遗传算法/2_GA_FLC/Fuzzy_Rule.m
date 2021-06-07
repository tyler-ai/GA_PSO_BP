function Delta_e=Fuzzy_Rule(r_t,m_f_p,m_f_n,e,er);

if e<=-1 %约束e
    e=-1;
elseif e>=1
    e=1;
end
if er<=-1%约束er
    er=-1;
elseif er>=1
    er=1;
end

ap=m_f_p(1);bp=m_f_p(2);cp=m_f_p(3);
an=m_f_n(1);bn=m_f_n(2);cn=m_f_n(3);

%建立隶属度函数
fuzzy_c=newfis('fuzzf');
fuzzy_c=addvar(fuzzy_c,'input','F',[-1,1]);
fuzzy_c=addmf(fuzzy_c,'input',1,'NL','zmf',[-1,an]);
fuzzy_c=addmf(fuzzy_c,'input',1,'ZR','trimf',[an,0,ap]);
fuzzy_c=addmf(fuzzy_c,'input',1,'PL','smf',[ap,1]);
fuzzy_c=addvar(fuzzy_c,'input','L',[-1,1]);
fuzzy_c=addmf(fuzzy_c,'input',2,'NL','zmf',[-1,bn]);
fuzzy_c=addmf(fuzzy_c,'input',2,'ZR','trimf',[bn,0,bp]);
fuzzy_c=addmf(fuzzy_c,'input',2,'PL','smf',[bp,1]);
fuzzy_c=addvar(fuzzy_c,'output','detae',[-1,1]);
fuzzy_c=addmf(fuzzy_c,'output',1,'NL','zmf',[-1,cn]);
fuzzy_c=addmf(fuzzy_c,'output',1,'ZR','trimf',[cn,0,cp]);
fuzzy_c=addmf(fuzzy_c,'output',1,'PL','smf',[cp,1]);

%建立规则表
rulelist=[1 1 r_t(1) 1 1;1 2 r_t(2) 1 1;1 3 r_t(3) 1 1;
          2 1 r_t(4) 1 1;2 2 r_t(5) 1 1;2 3 r_t(6) 1 1;
          3 1 r_t(7) 1 1;3 2 r_t(8) 1 1;3 3 r_t(9) 1 1];
      
fuzzy_c=addrule(fuzzy_c,rulelist);
fuzzy_rule_w=setfis(fuzzy_c,'DefuzzMethod','mom');
writefis(fuzzy_rule_w,'fuzzy_c');
fuzzy_rule_r=readfis('fuzzy_c');
 Delta_e=evalfis([e,er],fuzzy_rule_r);%模糊控制器输出