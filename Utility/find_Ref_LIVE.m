function ref_ind_live=find_Ref_LIVE(refnames_all)
     %此函数只是将每张失真图像找到其对应的参考图编号 后续测试时根据编号进行划分，
     %例如80%的参考图像及其所有失真图像用于训练，余下的用于测试...，
     %此划分方式会使训练样本和测试样本没有重合的图像
     
    refimgnames=unique(refnames_all);
    refimgnum=length(refimgnames);
    refimg_index=zeros(779,1);
    
    for i=1:refimgnum
       ref=refimgnames{i};
       [~,ind]=find(strcmp(refnames_all,ref));
       refimg_index(ind)=i;   
    end
    ref_ind_live=refimg_index;
      
end