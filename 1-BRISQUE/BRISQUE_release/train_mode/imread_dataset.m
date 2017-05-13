
clc;
clear all;

% dataset_root='F:\RANJIEWEN\IQA论文\DataSet';
% directory setup
img_dir = 'image_set';                      % directory for dataset images
data_set='LIVE';
rt_img_dir=fullfile(img_dir,data_set);
load('image_set/LIVE/dmos.mat');

data_dir = 'feature_data';                  % directory to save the sift features of the chosen dataset
rt_data_dir = fullfile(data_dir, data_set);

fprintf('dir the database...\n');
subfolders = dir(rt_img_dir);

% dmos=[dmos_jpeg2000(1:227) dmos_jpeg(1:233) white_noise(1:174) gaussian_blur(1:174) fast_fading(1:174)]

image_total_feat=[];
image_total_label=[];
image_total_scores=[];

je2k_scores=dmos(1:227);
jpeg_scores=dmos(228:460);
white_noise_scores=dmos(461:634);
gaussian_blur_scores=dmos(635:808);
fast_fading_scores=dmos(809:982);

% iamge_score.je2k_scores=je2k_scores;
% iamge_score.fast_fading_scores=fast_fading_scores;

for ii = 1:length(subfolders),
    subname = subfolders(ii).name;
    if ~strcmp(subname, '.') & ~strcmp(subname, '..'),
        frames = dir(fullfile(rt_img_dir, subname, '*.bmp'));
        c_num = length(frames);
        
        if c_num>0
            siftpath = fullfile(rt_data_dir,subname);
            if ~isdir(siftpath),
                mkdir(siftpath);
            end;
        end;
        
        for jj = 1:c_num,
            imgpath = fullfile(rt_img_dir, subname, frames(jj).name);
            imdist = imread(imgpath);
            
            if(size(imdist,3)==3)
                imdist = uint8(imdist);
                imdist = rgb2gray(imdist);
            end
            imdist = double(imdist);
            feat=[];
            feat = [feat; brisque_feature(imdist)];
            %disp('feat computed')
            
            [pdir, fname] = fileparts(frames(jj).name);
            fpath = fullfile(rt_data_dir, subname, [fname, '.mat']);
            
            char_num=fname(4:end);
            num=str2num(char_num);
            switch subname
                case 'fastfading'
                    image_total_scores=[image_total_scores ; fast_fading_scores(num)];
                    image_total_feat=[image_total_feat;feat];
                case 'gblur'
                    image_total_scores=[image_total_scores ; gaussian_blur_scores(num)];
                    image_total_feat=[image_total_feat;feat];
                case 'jp2k'
                    image_total_scores=[image_total_scores ; je2k_scores(num)];
                    image_total_feat=[image_total_feat;feat];
                case 'jpeg'
                    image_total_scores=[image_total_scores ; jpeg_scores(num)];
                    image_total_feat=[image_total_feat;feat];
                case 'wn'
                    image_total_scores=[image_total_scores ; white_noise_scores(num)];
                    image_total_feat=[image_total_feat;feat];
                case 'refimgs'
                    
                otherwise
                    disp(fullfile('子文件夹无法匹配...',fpath))
            end
            %save(fpath, 'feat');
        end;
    end;
end;

save(fullfile(rt_data_dir,'image_total_feat.mat'), 'image_total_feat');
save(fullfile(rt_data_dir,'image_total_scores.mat'),'image_total_scores')
disp('extract feature finished!......');

