function [e, y, w] = myLMS(d, x, mu, M)
% Inputs:
% d  - 麦克风语音
% x  - 远端语音
% mu - 步长，0.05
% M  - 滤波器阶数，也称为抽头数
%
% Outputs:
% e - 输出误差，近端语音估计
% y  - 输出系数，远端回声估计
% w - 滤波器参数

    d_length = length(d);
    if (d_length <= M)  
        print('error: 信号长度小于滤波器阶数！');
        return; 
    end
    if (d_length ~= length(x))  
        print('error: 输入信号和参考信号长度不同！');
        return; 
    end

    xx = zeros(M,1);
    w1 = zeros(M,1);    % 滤波器权重
    y = zeros(d_length,1);  % 远端回声估计
    e = zeros(d_length,1);  % 近端语音估计

    % for n = 1:Ns
    %     xx = [xx(2:M);x(n)];    % 纵向拼接
    %     xx(2~40)+x(1)-->xx(2~40)+x(2)-->xx(2~40)+x(3)...
    %     y(n) = w1' * xx;        % 远端回声估计(40,1)'*(40,1)=1; (73113,1)
    %     e(n) = d(n) - y(n);     % 近端语音估计
    %     w1 = w1 + mu * e(n) * xx;   % (40,1)
    %     w(:,n) = w1;        % (40, 73113)
    % end
    % 和上面类似
    for n = M:d_length
        xx = x(n:-1:n-M+1);    % 纵向拼接  (40~1)-->(41~2)-->(42~3)....
        y(n) = w1' * xx;        % 远端回声估计 (40,1)'*(40,1)=1; (73113,1)
        e(n) = d(n) - y(n);     % 近端语音估计
        w1 = w1 + mu * e(n) * xx;   % (40,1)
        w(:,n) = w1;        % (40, 73113)
    end
end