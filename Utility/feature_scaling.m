function SVFM = feature_scaling(VecFeaMat)
% Input:  VecFeaMat --- 需要scaling的 m*n 维数据矩阵，每行一个样本特征向量，列数为维数
%
% output: SVFM --- VecFeaMat的 scaling 版本

% 缩放目标范围[-1, 1]
lTargB = -1;
uTargB = 1;


[m n] = size(VecFeaMat);

SVFM = zeros(m, n);

% %特征归一化-(均值-方差)
% u=mean(x,1); %对每列求均
% sagma=std(x,1,1); %按列分，第二位是0-(除n-1);1(除n)
% for i=1:sample_num
%     x(i,:)=(x(i,:)-u)./sagma;
% end

%% 特征归一化-(min-max)
max_row=max(VecFeaMat,[],1);
min_row=min(VecFeaMat,[],1);
for i=1:m;
    SVFM(i,:)=(VecFeaMat(i,:)-min_row)./(max_row-min_row)*(1-(-1))+(-1); %数值相除
end

