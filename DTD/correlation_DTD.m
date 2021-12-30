fid1 = fopen('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data4_webrtc双讲测试\中文\local_double.pcm','r');
x1 = fread(fid1,inf,'int16');
fid2 = fopen('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data4_webrtc双讲测试\中文\remote_double.pcm','r');
x2 = fread(fid2,inf,'int16');

% Near_End_Signal = getaudiodata(NearVoice);
% sound(Near_End_Signal,8000)
% Far_End_Signal = getaudiodata(FarVoice);
% %Far_End_Signal = zeros(40000,1);
% MixedSignal = Far_End_Signal + Near_End_Signal;

subplot(2,1,1);
plot(x1);
title('Near End Signal');
subplot(2,1,2);
plot(x2);
title('Far End Signal');
% figure,plot(MixedSignal);
% title('Mixed Signal');

CrossCorrelate_FAR_MIXED =xcorr(x1,x2);
NewNear = x1.*x1;
NewFar = x2.*x2;
for i=1:length(CrossCorrelate_FAR_MIXED)
    CrossCorrelate_FAR_MIXED(i) = CrossCorrelate_FAR_MIXED(i)/sqrt(mean(NewNear)*mean(NewFar));
end

DecisionParameter = max(abs(CrossCorrelate_FAR_MIXED));

if DecisionParameter > 1000
    disp('Double Talk Detected');
else
    disp('Double Talk Not Present');
end

CrossCorrelate_FAR_MIXED = abs(CrossCorrelate_FAR_MIXED);
DTDSignal = zeros(1,length(x2));

for i=1:length(x2)
    if x1(i)-x2(i)>0
        DTDSignal(i) = 1;
    end
end
figure,plot(CrossCorrelate_FAR_MIXED);
title('DTD Proposed Alogrithm_Time at which Double talk Detected');