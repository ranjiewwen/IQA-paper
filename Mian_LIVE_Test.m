
clc;
clear all;
close all;

delete feat_data/*.mat
tic;

%----------------------- color_lbp----------------------------%%
alg_type='color_lbp';
feat_num=(10+2)*3+10; %
is_feature_scale=true;
is_srocc_search=false;
%% 提取特征   
imdb = Get_LIVE_Data(alg_type,feat_num);
%% 结果
result=Get_LIVE_Result(alg_type,is_feature_scale,is_srocc_search)


%% 保存结果
runtime=toc;
result.runtime=runtime/3600;
result.feat_num=feat_num;
save(sprintf('Result/LIVE_%s_%d_featnum_%d_result_ALL.mat',alg_type,is_srocc_search,feat_num),'result');


