clear all;
V=10;                 %输出幅度
eb_ratio=20;          %信噪比
sample=1000;          %信息样本长度

prn=PRseries(sample); %生成伪随机序列
src=PCMcode(prn,V,3); %信源编码(NRZ)
alfa=0.247;           %光纤的损耗常数，单位为dB/km
l=100;                %光纤长度，单位为km

Aled=0.9;             %光源增益
trans=Aled*src;       %光源将注入电流信号转化为光功率信号
trans=10^(-alfa*1/10)*trans; %光功率信号在光纤中传输，信号被衰减
recv=photo_detect(trans);     %p-i-n光接收器输出
yout=awgn(recv,eb_ratio,'measured'); %叠加等效高斯白噪声
[B,A]=butter(16,1/4);               %用户定义的匹配滤波器（这里用8阶butterworth滤波器），截止数字角频率4/16=1/4
Azeros=zeros(1,16);
vout=filter(B,A,[yout Azeros]); %考虑滤波器的时延，输入数据后面补16个零

Vth=(max(vout)-min(vout))*0.5; %判决边界
for i=1:sample
    if(vout(i*16+8:16:(i+1)*16)>Vth) %检测NRZ码，采样率=T/16，考虑滤波器的时延，前面32个数据去掉
        cout(i)=0;
    else
        cout(i)=1;
    end
end  

figure(1);

M_plot=[1:1:1000];
subplot(3,1,1)
plot(M_plot,trans(1:16:16000))%发射信号
title('发射信号')
axis([0,200,-2,10]);
hold on;
subplot(3,1,2)
plot(M_plot,yout(1:16:16000))%接收原始信号
title('接收原始信号')
axis([0,200,-2,10]);
hold on;
subplot(3,1,3)
plot(M_plot,cout(1:1:1000))%判决后信号
title('判决后信号')
axis([0,200,-0.25,1.25]);
hold on;

ber=sum(abs(cout(1:sample)-prn(1:sample)))/sample %误码率计算

xt=repmat([1:32],1,sample/2);                     %眼图绘制
figure(2);
plot(xt,vout(17:16*sample+16),'LineWidth',0.75);