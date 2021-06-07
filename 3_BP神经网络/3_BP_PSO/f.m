function y = f( x )
global SamIn SamOut HiddenUnitNum InDim OutDim TrainSamNum
W1 = x(1:HiddenUnitNum*InDim);
L1 = length(W1);

W1 = reshape(W1,[HiddenUnitNum, InDim]);

B1 = x(L1+1:L1+HiddenUnitNum)';
L2 = L1 + length(B1);
W2 = x(L2+1:L2+OutDim*HiddenUnitNum);
L3 = L2 + length(W2);
W2 = reshape(W2,[OutDim, HiddenUnitNum]);
B2 = x(L3+1:L3+OutDim)';

HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % 隐含层网络输出
NetworkOut = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % 输出层网络输出
Error = SamOut - NetworkOut;       % 实际输出与网络输出之差
y = sumsqr(Error);
end

