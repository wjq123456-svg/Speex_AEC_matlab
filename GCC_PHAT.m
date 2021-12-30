function y = GCC_PHAT(x1, x2)
% Note:
%       这个函数用GCC_toda来计算时延
% Usage:
%       y = GCC_tdoa(x1, x2)
% Input arguments:
%       x1 : 第一个通道信号 (1*N)
%       x2 : 第二个通道信号 (1*N)
% Output arguments:
%       y  : the GCC-PHAT function (1*(2*N-1))
% For example:
%       x1 = randn(1,2000);
%       x2 = delayseq(x1, 5e-3, 8000); % 对x1进行平移5ms，采样率为8kHz
%       y  = %%%;
% 说明：
%       本函数用来实现两路信号的GCC-PHAT的计算
%       输入：两路具有时延关系的信号（要求两信号等长）
%       输出：GCC-PHAT
% --------------------------------------------------------------
% 初始化
Ncorr = 2*length(x1)-1;   % 线性互相关长度
NFFT = 2^nextpow2(Ncorr); % 计算FFT点数
% --------------------------------------------------------------
% 计算GCC-PAHT
X= fft(x1', NFFT);
Y=fft(x2', NFFT); 
gcc=X.*conj(Y);
G=abs(X).*abs(Y);
gcc=gcc./G;
gcc=fftshift(ifft(gcc));
gcc=abs(gcc);
y = gcc(NFFT/2+1-(Ncorr-1)/2:NFFT/2+1+(Ncorr-1)/2); % 确定索引
disp(NFFT);
end