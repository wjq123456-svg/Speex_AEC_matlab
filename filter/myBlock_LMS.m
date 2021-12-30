function [e, y, w] = myBlock_LMS(d,x,mu, M,L)
    % 输入：
    % d - 麦克风语音
    % x - 远端语音
    % mu - 步长
    % M - 滤波器阶数
    % L - 块大小
    %
    % Outputs:
    % e - 输出误差，近端语音估计
    % y - 输出系数，远端回声估计
    % w - 滤波器参数
    
    d_length =length(d);
    K = floor(d_length / L);
    y = zeros(d_length,1);
    w = zeros(M,K+1);
    e = zeros(d_length,1);
    x_ = [zeros(M-1,1); x];
    
    % 根据"块"进行循环
    for k=1:K
        block_sum = 0;
        %求一个块的和sum
        for i = 1+L*(k-1):L*k
                X = x_(i:i+M-1);
                y(i) = w(:,k)' * X; %滤波器输出
                
                e(i) = d(i) - y(i);
                block_sum = block_sum + X* e(i); %权重更新
        end
        
            w(:,k+1) = w(:,k) + mu * block_sum;
    end
    
    %将指针移动一步，使第n行对应与时间n
    w = w(:,2:K+1);
end
      
    