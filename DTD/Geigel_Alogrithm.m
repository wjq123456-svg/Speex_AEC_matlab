fid1 = fopen('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data4_webrtc双讲测试\中文\local_double.pcm','r');
x1 = fread(fid1,inf,'int16');
fid2 = fopen('C:\Users\wjq\Desktop\智能软件项目中心\计划书和相关音频\data\data4_webrtc双讲测试\中文\remote_double.pcm','r');
x2 = fread(fid2,inf,'int16');

% Near_End_Signal = getaudiodata(NearVoice);
% sound(Near_End_Signal,8000)
% Far_End_Signal = getaudiodata(FarVoice);
% 
% MixedSignalG = Far_End_Signal + Near_End_Signal;
subplot(2,1,1);
plot(x1)
title('Near End Signal');
subplot(2,1,2);
plot(x2)
title('Far End Signal');
% figure,plot(MixedSignalG);
% title('Mixed Signal');

MixedSignalG = abs(x1);
DecisionVector = zeros(1,length(MixedSignalG));
l = zeros(1,length(MixedSignalG));

for i=1:length(MixedSignalG)
    DecisionVector(i) = MixedSignalG(i)/max(abs(x2));
    if DecisionVector(i)>1000
        l(i) = 1;
    end
end

if sum(l) > 0
    disp('Double Talk Detected');
else
    disp('Double Talk Not Present');
end
figure,plot(l);
title('Geigel Alogrithm_Time at which Double talk Detected');