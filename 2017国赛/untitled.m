clc;clear;
theta=1;180;
 A5=xlsread('/Users/rexzhang/Desktop/CUMCM2017Problems/A/A.xlsx',3);
 IR=iradon(A5,theta,'nearest','Hann');
 ss=find(abs(IR)<=0.1);
 IR(ss)=0;
 ss=find(IR);
  IR(ss)=IR(ss)*2.0425;
  ss=find(IR<0);
 IR(ss)=0;
 yuanxishoulv=zeros(256,256);
  for i=1:256
         for j=1:256
             i1=i-128.5;j1=j-128.5;             
             ii=1.4141*[cos(29.5532*pi/180) sin(29.5532*pi/180);-sin(29.5532*pi/180) cos(29.5532*pi/180)]*[i1;j1]+[217;198.5];
             ij=round(ii);
             if ij(1)>0 &&ij(1)<363 && ij(2)>0 && ij(2)<363
             yuanxishoulv(i,j)=IR(ij(1),ij(2));
             end
         end
  end
 
 xlswrite('/Users/rexzhang/Desktop/CUMCM2017Problems/A/A.xlsx',3,yuanxishoulv)
 imagesc(yuanxishoulv)