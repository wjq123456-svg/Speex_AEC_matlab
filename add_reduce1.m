clear;
close all;
clc;

%读取文件
fid1 = fopen('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data4_webrtc双讲测试\中文\local_double.pcm','r');
x1 = fread(fid1,inf,'int16');
fid2 = fopen('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data4_webrtc双讲测试\中文\remote_double.pcm','r');
x2 = fread(fid2,inf,'int16');
N =length(x1);
xcorrMat = xcorr(x1,x2,'biased');
[k,ind] = max(xcorrMat);
disp(N - ind);
delay_matrix=zeros(abs(N-ind),1);
zzzz = length(delay_matrix);
new = [x2;delay_matrix];
M = length(new);
new((1:zzzz),:) = [];
M1 =length(new);
x_new = x1 - new;

figure;
ax1 = subplot(311);
plot(x1);grid on;title("近端");
ax2 = subplot(312);
plot(x2);grid on;title("参考音频");
ax3 = subplot(313);
plot(x_new);grid on;title("消除后的声音");
sound(x1,8000);


