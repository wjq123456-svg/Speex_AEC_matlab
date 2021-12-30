% 参考：https://github.com/CharlesThaCat/acoustic-interference-cancellation
function [en, yk, W] = myFDAF(d,x,mu,mu_unconst, M, select)
% 参数:
% d                输入信号(麦克风语音)
% x                远端语音
% mu                约束 FDAF的步长
% mu_unconst        不受约束的 FDAF的步长
% M                 滤波器阶数
% select;            选择有约束或无约束FDAF算法
%
% 参考:        
% S. Haykin, Adaptive Filter Theory, 4th Ed, 2002, Prentice Hall
% by Lee, Gan, and Kuo, 2008
% Subband Adaptive Filtering: Theory and Implementation
% Publisher: John Wiley and Sons, Ltd

x_new = zeros(M,1);     % 将新块的M个样本初始化为0
x_old = zeros(M,1);     % 将旧块的M个样本初始化为0

AdaptStart = 2*M;       % 在获得2M个样本块后开始自适应
W = zeros(2*M,1);       % 将2M个滤波器权重初始化为0
d_block = zeros(M,1);   % 将期望信号的M个样本初始化为0

power_alpha = 0.5;        % 常数以更新每个frequency bin的功率
power = zeros(2*M,1);   % 将每个bin的平均功率初始化为0
d_length = length(d);             % 输入序列的长度
en = [];                       % 误差向量
window_save_first_M = [ones(1,M), zeros(1,M)]';  % 设置向量以提取前M个元素 (2M,1)


for k = 1:d_length
    x_new = [x_new(2:end,:); x(k)];         % 开始的输入信号块 (2M,1)
    d_block = [d_block(2:end,:); d(k)];     % 开始的期望信号快 (M,1)
    if mod(k,M)==0                        % If iteration == block length, 
        x_blocks = [x_old; x_new];        % 2M样本的输入信号样本块 (2M,1)
        x_old = x_new;
        if k >= AdaptStart                % 频域自适应滤波器

            % 将参考信号转换到频域
            Xk = fft(x_blocks);     % (2M,1)
            % FFT[old block; new block]
            % Old block 包含M个先前的输入样本 (u_old)
            % New 包含M个新的输入样本 (u_new)

            % 计算滤波器估计信号
            Yk = Xk.*W;                  % 输入和权重向量的乘积(2M,1)*(2M,1)=(2M,1)
            temp = real(ifft(Yk));            % IFFT 输出的实部 (2M,1)
            yk = temp(M+1:2*M);               % 抛弃前M个元素，保留后M个元素 (M,1)

            % 计算误差信号
            error = d_block-yk;              % 误差信号块 (M,1)
            Ek = fft([zeros(1,M),error']');   % 在FFT之前插入零块以形成2M块(2M,1)

            % 更新信号功率估算
            power = (power_alpha.*power) + (1 - power_alpha).*(abs(Xk).^2); % (2M,1)

            % 计算频域中的梯度和权重更新
            if select == 1
                gradient = real(ifft((1./power).*conj(Xk).* Ek));   % (2M,1)
                gradient = gradient.*window_save_first_M;   % 去除后一个数据块，并且补零 (2M,1)
                W = W + mu.*(fft(gradient));    % 权重是频域的 (2M,1)
            else
                gradient = conj(Xk).* Ek;   %  (2M,1)
                W = W + mu_unconst.*gradient;    % (2M,1)
            end
            
            en = [en; error];             % 更新误差块
        end
    end
end

            