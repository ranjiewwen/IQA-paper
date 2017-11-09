function feat = feat_extract_all(im2color)

addpath(genpath('color_feat'));
addpath(genpath('lbp'));

% Convert the input RGB image to LMS color space.
lms = convertRGBToLMS(im2color);
%figure;imshow((lms));
featOpp = lmsColorOpponentFeats(lms); % Color opponency features.

%------------------------------------------------
% Feature Computation
%-------------------------------------------------
scalenum = 3;
window = fspecial('gaussian',3,3/2); % fspecial函数用于创建预定义的滤波算子
window = window/sum(sum(window));

%% LBP
R = 1; P = 8;
lbp_type = { 'ri' 'u2' 'riu2' };
y = 3;
mtype = lbp_type{y};
MAPPING = getmapping( P, mtype );

feat = [];
imdist=double(rgb2gray(im2color));
%tic  %在MATLAB里面可以使用tic和toc命令得到运行时间
for itr_scale = 1:scalenum
    %im2color = imdist;
    mu            = filter2(window, imdist, 'same');
    mu_sq         = mu.*mu;
    sigma         = sqrt(abs(filter2(window, imdist.*imdist, 'same') - mu_sq));
    structdis     = (imdist-mu)./(sigma+1);
    %figure;imshow(mat2gray(structdis));
    [alpha overallstd]       = estimateggdparam(structdis(:));   % GGD
    feat                     = [feat alpha overallstd];  % 
        
    %%%%%%%%%% MSCN LBP %%%%%%%%%%%%
    LBPMap = lbp_new(structdis,R,P,MAPPING,'x');
    %%%%%% gradient magnitude weighted GLBP %%%%%
    wLBPHist = [];
    weightmap = structdis;
    wintesity = weightmap(2:end-1, 2:end-1);
    wintensity = abs(wintesity);
    for k = 1:max(LBPMap(:))+1
        idx = find(LBPMap == k-1);
        kval = sum(wintensity(idx));
        wLBPHist = [wLBPHist kval];
    end
    wLBPHist = wLBPHist/sum(wLBPHist);
    feat = [feat wLBPHist]; 
    
    if itr_scale==1;
        feat=[feat featOpp];
    end
    
    imdist                   = imresize(imdist,0.5);
    
end
%toc
