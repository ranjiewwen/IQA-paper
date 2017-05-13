
%To assess the quality of a given image

templateModel = load('templatemodel.mat');
templateModel = templateModel.templateModel;
mu_prisparam = templateModel{1};
cov_prisparam = templateModel{2};
meanOfSampleData = templateModel{3};
principleVectors = templateModel{4};

%imDis is a RGB colorful image
imDis=imread('F:\RANJIEWEN\IQA\IQAÂÛÎÄ\code\ILNIQE\pristine\01.jpg');
metricValue = computequality(imDis,mu_prisparam,cov_prisparam,principleVectors,meanOfSampleData);


%To re-train the prinstine model

%training