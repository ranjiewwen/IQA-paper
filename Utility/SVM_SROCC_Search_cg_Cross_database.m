function [src,bestc,bestg] = SVM_SROCC_Search_cg_Cross_database(imdb,cmin,cmax,gmin,gmax,v,cstep,gstep,msestep)
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
if nargin < 9
    msestep = 0.06;
end
if nargin < 7
    cstep = 1;
    gstep = 1;
end
if nargin < 6
    v = 5;
end
if nargin < 4
    gmax = 16;
    gmin = -16;
end
if nargin < 2
    cmax = 16;
    cmin = -16;
end
%% X:c Y:g cg:acc
[X,Y] = meshgrid(cmin:cstep:cmax,gmin:gstep:gmax);
[m,n] = size(X);
cg = zeros(m,n);
eps = 10^(-4);

x=imdb.x; %  trian图像的特征
y=imdb.y; %  train图像的DMOS/MOS

x1=imdb.x1;% test
y1=imdb.y1;

N = 5; % repeatation times 10
%% record acc with different c & g,and find the bestacc with the smallest c
bestc = 0;
bestg = 0;
src = 0;
basenum = 2;

for i = 1:m
    for j = 1:n
        cmd = [' -c ',num2str( basenum^X(i,j) ),' -g ',num2str( basenum^Y(i,j) ),' -s 3 -p 0.1 -h 0'];
        
        for z = 1:N
           
            model = libsvmtrain(y,x,cmd);
            [predict_score, ~, ~] = libsvmpredict(y1, x1, model);
            SRCC(z) = corr(predict_score, y1,'type','Spearman');       
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







