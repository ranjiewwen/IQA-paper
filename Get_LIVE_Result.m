
function result=Get_LIVE_Result(alg_type,is_feat_scale,is_srocc_search)
%% Training process

load(sprintf('Result/LIVE_%s_data.mat',alg_type));
load('Result/LIVE_dist_type.mat');
% dmos_new_live:
%       the subjective distortion score of LIVE database
% ind_live:
%       bool variables, 0 indicates a pristine image and 1 indicates a
%       distorted image, the pristine image will be removed in experiments.
% ref_ind_live:
%       vectors to indicate the index of the reference image for all the
%       image. This will be used in the spliting of the traning set and
%       testing set.
% live_feature:
%       the NR feature for all the image in LIVE databases, each row for one image.

%% preparing the data for traning and test

%% feature scaling
if is_feat_scale
    if strcmp(alg_type,'GWH_GLBP')
        live_feature = sqrt(live_feature);   %%%% feature normalization
    else
        live_feature=feature_scaling(live_feature);
    end
end;

Ref_number = max(ref_ind_live); % The numbe of refe rence image 29

N = 1000; % repeatation times 1000

% splitting the databases acroding to the reference index
REF = round(Ref_number*0.8);
C = zeros(N,REF);
for j = 1:N
    rand_order = randperm(Ref_number);
    C(j,:) = rand_order(1:REF);
end

data = live_feature(ind_live,:); % input data to the SVR model
label = dmos_new_live(ind_live); % output of the SVR model
image_distortion_type=image_distortion_type(ind_live); %779
% the (cost, gamma) parameters for the SVR learning
% svr参数寻优
imdb.x=data;
imdb.y=label;
imdb.ref_ind=ref_ind_live;
imdb.ref=refnames_all';
bestc=0;
bestg=0;
if is_srocc_search
    %[bestCVmse,bestc,bestg]=SVMcgForIQA(imdb,label,data);
    [bestCVmse,bestc,bestg]=SVM_SROCC_Search_cg(imdb);
else
    train = ismember(ref_ind_live,C(1,:)); % C(1,:)
    test = ~train;
    [bestCVmse,bestc,bestg]=SVMcgForRegress(label(train),data(train,:));
end

c_str = sprintf('%f',bestc);
g_str = sprintf('%.2f',bestg);
libsvm_options = ['-s 3 -t 2 -g ',g_str,' -c ',c_str];

%libsvm_options=['-s 3 -t 2 -c ',num2str(8192),' -g ',num2str(0.0313),' -p 0.1'];

spear_results = zeros(N,1);
plcc_results=zeros(N,1);
spear_results_jp2k=zeros(N,1);
plcc_results_jp2k=zeros(N,1);
spear_results_jpeg = zeros(N,1);
plcc_results_jpeg = zeros(N,1);
spear_results_wn = zeros(N,1);
plcc_results_wn = zeros(N,1);
spear_results_GB = zeros(N,1);
plcc_results_GB = zeros(N,1);
spear_results_FF = zeros(N,1);
plcc_results_FF = zeros(N,1);

% Training and Test procedure
for i = 1:N
    % get the index of the distorted image from the index of the reference
    % image for the traning set and the test set.
    train = ismember(ref_ind_live,C(i,:)); % C(1,:)
    test = ~train;
    
    %% LIVE整库训练
    model = libsvmtrain(label(train),data(train,:),libsvm_options);
    %% LIVE整库测试
    [predict_score, ~, ~] = libsvmpredict(label(test), data(test,:), model);
    spear_results(i) = corr(predict_score, label(test),'type','Spearman'); 
    score_fit = nonlinear_fit(predict_score, label(test));
    plcc_results(i)=corr(score_fit, label(test),'type','Pearson');
      
    %% jp2k,jpeg,wn,GB,FF分项测试
    test_jp2k= test & (image_distortion_type==1); 
    [predict_score_jp2k, ~, ~] = libsvmpredict(label(test_jp2k), data(test_jp2k,:), model);
    spear_results_jp2k(i) = corr(predict_score_jp2k, label(test_jp2k),'type','Spearman'); 
    score_fit_jp2k = nonlinear_fit(predict_score_jp2k, label(test_jp2k));
    plcc_results_jp2k(i)=corr(score_fit_jp2k, label(test_jp2k),'type','Pearson');
    
    test_jpeg=test & (image_distortion_type==2); 
    [predict_score_jpeg, ~, ~] = libsvmpredict(label(test_jpeg), data(test_jpeg,:), model);
    spear_results_jpeg(i) = corr(predict_score_jpeg, label(test_jpeg),'type','Spearman'); 
    score_fit_jpeg = nonlinear_fit(predict_score_jpeg, label(test_jpeg));
    plcc_results_jpeg(i)=corr(score_fit_jpeg, label(test_jpeg),'type','Pearson');
    
    test_wn=test & (image_distortion_type==3); 
    [predict_score_wn, ~, ~] = libsvmpredict(label(test_wn), data(test_wn,:), model);
    spear_results_wn(i) = corr(predict_score_wn, label(test_wn),'type','Spearman'); 
    score_fit_wn = nonlinear_fit(predict_score_wn, label(test_wn));
    plcc_results_wn(i)=corr(score_fit_wn, label(test_wn),'type','Pearson');
    
    test_GB=test & (image_distortion_type==4); 
    [predict_score_GB, ~, ~] = libsvmpredict(label(test_GB), data(test_GB,:), model);
    spear_results_GB(i) = corr(predict_score_GB, label(test_GB),'type','Spearman'); 
    score_fit_GB = nonlinear_fit(predict_score_GB, label(test_GB));
    plcc_results_GB(i)=corr(score_fit_GB, label(test_GB),'type','Pearson');
    
     test_FF=test & (image_distortion_type==5); 
    [predict_score_FF, ~, ~] = libsvmpredict(label(test_FF), data(test_FF,:), model);
    spear_results_FF(i) = corr(predict_score_FF, label(test_FF),'type','Spearman'); 
    score_fit_FF = nonlinear_fit(predict_score_FF, label(test_FF));
    plcc_results_FF(i)=corr(score_fit_FF, label(test_FF),'type','Pearson');
    
end
% median Spearman Coefficient (SRC) performance
spear_median = median(spear_results);
spear_std = std(spear_results,0);
spear_max = max(spear_results);
spear_min = min(spear_results);
plcc_median = median(plcc_results);
plcc_max = max(plcc_results);
plcc_min = min(plcc_results);

info=strcat('LIVE--',alg_type,'--Order_by_name--',sprintf('is_srocc_search: %d ',is_srocc_search) );

result.info=info;
result.bestc=bestc;
result.bestg=bestg;
result.libsvm_options=libsvm_options;
result.spear_median=spear_median;
result.spear_max=spear_max;
result.spear_min=spear_min;
result.plcc_median=plcc_median;
result.plcc_max=plcc_max;
result.plcc_min=plcc_min;
result.cur_date=datestr(clock);

result.spear_median_jp2k= median(spear_results_jp2k);
result.plcc_median_jp2k=median(plcc_results_jp2k);

result.spear_median_jpeg= median(spear_results_jpeg);
result.plcc_median_jpeg=median(plcc_results_jpeg);

result.spear_median_wn= median(spear_results_wn);
result.plcc_median_wn=median(plcc_results_wn);

result.spear_median_GB= median(spear_results_GB);
result.plcc_median_GB=median(plcc_results_GB);

result.spear_median_FF= median(spear_results_FF);
result.plcc_median_FF=median(plcc_results_FF);
end

function [x_fit]= nonlinear_fit(x,y)
if corr(x,y,'type','Pearson')>0
    beta0(1) = max(y) - min(y);
else
    beta0(1) = min(y) - max(y);
end
beta0(2) = 1/std(x);
beta0(3) = mean(x);
beta0(4) = -1;
beta0(5) = mean(y);

beta = nlinfit(x,y,@logistic5,beta0);
x_fit = feval(@logistic5, beta, x);
end

function f = logistic5(beta, x)
f = beta(1).*(0.5-(1./(1+exp(beta(2).*(x-beta(3)))))) + beta(4).*x + beta(5);    
end

