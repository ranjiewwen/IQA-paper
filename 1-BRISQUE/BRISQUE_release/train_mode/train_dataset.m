clc;
clear all;

load('feature_data/LIVE/image_total_feat.mat');
load('feature_data/LIVE/image_total_scores.mat');

x=image_total_feat;
%特征归一化
sample_num=size(x,1);
u=mean(x,1);
sagma=std(x,0,1);
for i=1:sample_num
    x(i,:)=(x(i,:)-u)./sagma;
end
y=image_total_scores;

iter=1000;
for i = 1:iter
    
    %训练数据
    num_train=length(y)*0.8;
    choose=randperm(length(x));
    train_data = x(choose(1:num_train),:);
    train_scores = y(choose(1:num_train),:);
    
    % 预测回归
    test_data = x(choose(num_train+1:end),:);
    test_scores=y(choose(num_train+1:end),:);
    predict = zeros(length(test_data),1);
    
    % 训练模型
    cmd=['-s 3 -t 2 -c 1 -g 2.8 -p 0.1'];%-g 2.8 
    model = libsvmtrain(y,x,cmd);
    
    [predict,tmse,detesvalue]  = libsvmpredict(test_scores,test_data,model);
    % 显示结果
    %display('预测数据');
    RHO(i,:)=corr(predict,test_scores,'type','Spearman');
end

result=median(RHO)




