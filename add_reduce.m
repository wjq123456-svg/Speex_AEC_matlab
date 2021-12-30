clear;
close all;
clc;


[x1, fs_n] = audioread('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data6_线路回声双讲\1m時延估計\neartoyou.wav');      
[x2, fs_f] = audioread('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data6_线路回声双讲\1m時延估計\混缩.wav'); 
[x3, fs_ns] = audioread('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data6_线路回声双讲\加噪声\混缩_噪声.wav'); 
[x4, fs_local] = audioread('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data6_线路回声双讲\1m時延估計\近端语音.wav'); 
[x5, fs_far] = audioread('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data6_线路回声双讲\1m時延估計\neartoyou_1ms延时.wav');



N =length(x3);
N1 = length(x4);
N2 = length(x1);
x_add = zeros(N-length(x4),1);
x4 = [x4;x_add];
x_new = x4+(x5/3);%混缩文件+噪声+三分之一的近端噪声
xcorrMat = xcorr(x1,x_new,'biased');
[k,ind] = max(xcorrMat);
delay_matrix=zeros(N-ind,1);
new = [delay_matrix;x1];
%disp(length(new));
M= length(new)
%添加延时
new((N+1:M),:)=[];
M1 = length(new)
x2 =x2 - new;
%进行消除
last = x_new-new/3;
delay_time = (N-ind)/fs_f *1000;
X = ['时延为',num2str(delay_time),'ms'];
%sound(last);
figure;
ax1 = subplot(511);
plot(x_new);grid on;title("混缩的声音(含噪声)");
ax3 = subplot(512);
plot(x1);grid on;title("参考音频");
ax2 = subplot(513);
plot(last);grid on;title("消除后的声音");
M=20;mu =0.05; L =10;
[e,y,w] = myBlock_LMS(x2,new,mu,M,L);
[e1,y1,w1] = myLMS(x2,new,mu,M);
ax4 =subplot(514);
plot(e); grid on;title("NLMS处理结果");
ax5 =subplot(515);
plot(e1); grid on;title("LMS处理结果");
sound(e1)






