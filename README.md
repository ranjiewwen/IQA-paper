# IQA-paper Image Quality Assessment 

## 实验方法

- (1)提取整个数据库图像的特征和对应的主观得分(DMOS/MOS); 
- (2)将参考图像随机分为80%和20%，找到对应的失真图像，得到80%的训练集和20%的测试集，该步骤保证了训练集和测试集没有任何重复图像; 
- (3)利用训练集对应的特征和质量得分训练评价模型，并预测测试图像集中图像质量得分; 
- (4)计算测试图像集中预测得分和真实得分之间的SROCC和PLCC;
- (5)重复(2),(3),(4)步骤1000次，选取1000次实验结果SROCC和PLCC的中值作为该算法最终评价指标。

## 颜色空间统计联合纹理特征的无参考图像质量评价

- 文件夹说明：

     - color_feat:为一些颜色特征提取的辅助函数

     - feat_data:为待评价图像中间特征结果

     - lbp：为lbp特征提取函数

     - Result:为程序结果保存

     - Utility：为提取拟合函数，LIVE库一些参数提取函数（其他库类似），SVR网格搜索函数


- m文件说明：

     - feat_extract_all：本文特征提取方法

     - Get_LIVE_Data：提取LIVE库的各种参数

     - Get_LIVE_Result：获得LIVE库上各种结果

     - Mian_LIVE_Test：LIVE库上主函数

## 运行方法

- 在`Get_LIVE_Data.m`函数中设置LIVE数据库的路径：`Data_Dir`即可；然后运行`Mian_LIVE_Test.m`

- 实验结果

```
result = 

                 info: 'LIVE--color_lbp--Order_by_name--is_srocc_search: 0'
                bestc: 256
                bestg: 0.1088
       libsvm_options: '-s 3 -t 2 -g 0.11 -c 256.000000'
         spear_median: 0.9599
            spear_max: 0.9823
            spear_min: 0.9163
          plcc_median: 0.9628
             plcc_max: 0.9823
             plcc_min: 0.9200
             cur_date: '09-Nov-2017 16:45:22'
    spear_median_jp2k: 0.9514
     plcc_median_jp2k: 0.9636
    spear_median_jpeg: 0.9714
     plcc_median_jpeg: 0.9844
      spear_median_wn: 0.9858
       plcc_median_wn: 0.9924
      spear_median_GB: 0.9439
       plcc_median_GB: 0.9570
      spear_median_FF: 0.9017
       plcc_median_FF: 0.9369

```

   
## 说明

- 实验过程中多谢[Image & Video Quality Assessment at LIVE ](http://live.ece.utexas.edu/research/quality/index.htm)实验室开源主页

- 本项目code只包含LIVE库代码，其他CSIQ,TID2013,MLIVE库实验可以类似实现，**发现之前滤波窗口设置为`7*7`，改为`3*3`实验效果更好**

- 实验结果可能有一些偏差，但不大，与SVR网格搜索寻优有关或者其他随机因素
   
- 代码框架容易拓展，包括其他库的实现和添加新的算法
  
- 以后努力方向：利用CNN实现特征提取和实现端到端的图像质量评价
