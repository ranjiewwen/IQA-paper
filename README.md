# IQA-paper Image Quality Assessment 

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

   
## 说明

- 实验过程中多谢[Image & Video Quality Assessment at LIVE ](http://live.ece.utexas.edu/research/quality/index.htm)实验室开源主页

- 本项目code只包含LIVE库代码，其他CSIQ,TID2013,MLIVE库实验可以类似实现
   
- 代码框架容易拓展，包括其他库的实现和添加新的算法
  
- 以后努力方向：利用CNN实现特征提取和实现端到端的图像质量评价
