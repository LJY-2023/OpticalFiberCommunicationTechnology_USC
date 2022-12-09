function[amp,x]=photo_detect(pt)
nt=size(pt,2);
lambda_c=1.51*10^-6; %波长
dt=1.25e-7;         %光电转换的响应时间
h=6.626*10^-34;    %普朗克常量
c=3*10^8;         %光速
e=1.602*10^-19;   %电子电量
vs=c/lambda_c;    %光子频率
yita=0.8;         %光子利用率
Id=5e-9;         %暗电流5nA
x=1:nt;
for i=1:nt
    N(i)=(yita/(h*vs)*pt(i)+Id/e)*dt; %接收光子数，pt为信号能量
    pn=poissrnd(N(i));                %接收量符合Poisson分布
    amp(i)=e*pn/dt;                  %输出电流
end