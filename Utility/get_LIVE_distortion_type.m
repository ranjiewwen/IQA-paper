function  image_distortion_type  = get_LIVE_distortion_type( Data_Dir ,image_path)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
image_distortion_type=zeros(982,1);

for i=1:227  %jp2k-jpeg-wn-GB
    image_distortion_type(i)=1;
end
for i=228:460 %jpeg
    image_distortion_type(i)=2;
end
for i=461:634 % wn
    image_distortion_type(i)=3;
end

for i=635:808 % GB
    image_distortion_type(i)=4;
end

for i=809:982 % FF
    image_distortion_type(i)=5;
end

end

