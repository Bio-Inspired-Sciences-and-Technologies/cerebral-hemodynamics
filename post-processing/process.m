s1='spool_';
s4='00';
param_file_name = '../LSCI/metaSpool.txt';
ss1='../LSCI/1/';
ss2='.dat';
a={};
b=[];
for i=1001:1682
    s2=num2str(i);
    s3=[s1 s4 s2];
    ss3=[ss1 s3 ss2];
    rawDataFileName =ss3;
    [andorImage, bFileDoesNotExist] = readAndorDatImage (rawDataFileName, param_file_name);
%     b=[b sum(sum((andorImage)))];
     a{i-1000}=andorImage;
end
% % STD=std(b);
% % ave=mean(b);
% % figure;plot(b);
% x=[];
% x2=zeros(1000,1000);
% x3=[];
% for j=2:378
%     x=im2double(a{j}-a{j-1});
%     x2=x2+x;
%     x3(:,:,j-1)=mat2gray(x);
% end
% 
%  implay(x3)