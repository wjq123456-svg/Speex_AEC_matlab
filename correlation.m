%互相关的不同计算方法
clear;
close all;
clc;
%原始信号
[x2, fs_n] = audioread('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data6_线路回声双讲\1m時延估計\neartoyou_1ms延时.wav');      
[x1, fs_f] = audioread('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data6_线路回声双讲\1m時延估計\neartoyou.wav');
x3=audioread('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data6_线路回声双讲\1m時延估計\近端语音.wav');
x4=audioread('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data6_线路回声双讲\1m時延估計\混缩.wav');

 N = length(x2);
% NFFT=2^nextpow2(N);
%传统时域法
% xcorrTime = zeros(2*N-1,1);
% m = 0;
% for i = -(N-1):N-1
%     m = m+1;
%     for t = 1:N
%         if 0<(i+t) &&(i+t)<=N
%             xcorrTime(m) =xcorrTime(m) + x2(t) *x1(t+i);
%         end
%     end
% end

% xcorrTime = xcorrTime'/N;

% %频域法

% xcorrfft = fftshift(ifft(fft(x1,Nfft).*conj(fft(x2,Nfft))));
% 
%Matlab自带xcorr计算
xcorrMat = xcorr(x1,x2,'biased');
[k,ind] = max(xcorrMat);

% % 频域计算GCC-PHAT
% Gss = fft(x1,NFFT).*conj(fft(x2,NFFT));
% Gss = Gss./abs(Gss);
% % Gss = exp(1i*angle(Gss)); % 这种方式也可以
% xcorrGcc = fftshift(ifft(Gss));
delay_time = (N-ind)/fs_f *1000; 
X = ['时延为',num2str(delay_time),'ms'];
disp(X)
figure;
% ax1 = subplot(311);
plot(xcorrMat);grid on;
title('xcorrMat');

y = GCC_PHAT(x1, x2);
%plot(xcorrGcc);grid on;
%title('xcorrGcc');
%figure;
%plot(y);
%Y= length(y);grid on;
%delay_time = (N-)/fs_f *1000;
%title('xcorr');

