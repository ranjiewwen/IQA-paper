function [src,bestc,bestg] = SVMcgForIQA(imdb,label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,msestep)
%SVMcg cross validation by faruto

%% 若转载请注明：
% faruto and liyang , LIBSVM-farutoUltimateVersion
% a toolbox with implements for support vector machines based on libsvm, 2009.
% Software available at http://www.ilovematlab.cn
%
% Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for
% support vector machines, 2001. Software available at
% http://www.csie.ntu.edu.tw/~cjlin/libsvm


%% about the parameters of SVMcg
if nargin < 11
    msestep = 0.06;
end
if nargin < 9
    cstep = 1;
    gstep = 1;
end
if nargin < 8
    v = 5;
end
if nargin < 6
    gmax = 16;
    gmin = -16;
end
if nargin < 4
    cmax = 16;
    cmin = -16;
end
%% X:c Y:g cg:acc
[X,Y] = meshgrid(cmin:cstep:cmax,gmin:gstep:gmax);
[m,n] = size(X);
cg = zeros(m,n);
eps = 10^(-4);

% 得到无失真(参考)图像的名称
image_name = dir(fullfile('F:\RANJIEWEN\IQA\IQA论文\code\dataSet\LIVE\refimgs','*.bmp'));
image_name_list={};
for ii=1:length(image_name)
    subname = image_name(ii).name;
    image_name_list=[image_name_list,subname];
end

x=imdb.x;
y=imdb.y;
ref=imdb.ref;

%% record acc with different c & g,and find the bestacc with the smallest c
bestc = 0;
bestg = 0;
src = 0;
basenum = 2;

for i = 1:m
    for j = 1:n
        cmd = [' -c ',num2str( basenum^X(i,j) ),' -g ',num2str( basenum^Y(i,j) ),' -s 3 -p 0.1 -h 0'];
        
        for z = 1:10         
            % 选取无失真图像图像的80%
            num_train=round(length(image_name)*0.8);
            choose=randperm(length(image_name));
            train_data_name=image_name_list(choose(1:num_train));
            % 测试20%图像的名称
            test_data_name=image_name_list(choose(num_train+1:end));
            
            %% 训练数据
            train_data=[];
            train_scores=[];
            % 找到无失真图像对应的失真图像
            for k=1:length(train_data_name)
                [~,ind]=find(strcmp(ref',train_data_name{k})); % 参数1要使用一行
                train_data=[train_data ; x(ind,:)];
                train_scores=[train_scores ; y(ind,:)];
            end
            
            % 预测回归
            test_data = [];
            test_scores=[];
            for k=1:length(test_data_name)
                [~,ind]=find(strcmp(ref',test_data_name{k})); 
                test_data=[test_data ; x(ind,:)];
                test_scores=[test_scores ; y(ind,:)];
            end
            
          %% svm训练模型
            predict = zeros(length(test_data),1);
            model = libsvmtrain(train_scores,train_data,cmd);
            [predict,tmse,detesvalue]  = libsvmpredict(test_scores,test_data,model);
            
            SRCC(z)=corr(predict,test_scores,'type','Spearman');
            
        end
        
        cg(i,j) = median(SRCC);
        if cg(i,j) > src
            src = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
        end
        
        if abs( cg(i,j)-src )<=eps && bestc > basenum^X(i,j)
            src = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
        end
        
    end
end

% %% to draw the acc with different c & g
% [cg,ps] = mapminmax(cg,0,1);
% figure;
% [C,h] = contour(X,Y,cg,0:msestep:0.5);
% clabel(C,h,'FontSize',10,'Color','r');
% xlabel('log2c','FontSize',12);
% ylabel('log2g','FontSize',12);
% firstline = 'SVR参数选择结果图(等高线图)[GridSearchMethod]';
% secondline = ['Best c=',num2str(bestc),' g=',num2str(bestg), ...
%     'CVsrc=',num2str(src)];
% title({firstline;secondline},'Fontsize',12);
% grid on;
%
% figure;
% meshc(X,Y,cg);
% % mesh(X,Y,cg);
% % surf(X,Y,cg);
% axis([cmin,cmax,gmin,gmax,0,1]);
% xlabel('log2c','FontSize',12);
% ylabel('log2g','FontSize',12);
% zlabel('SRC','FontSize',12);
% firstline = 'SVR参数选择结果图(3D视图)[GridSearchMethod]';
% secondline = ['Best c=',num2str(bestc),' g=',num2str(bestg), ...
%     ' CVmse=',num2str(src)];
% title({firstline;secondline},'Fontsize',12);







