clear
close all
clc
 load JJJ171projiect.txt;
 MyData=JJJ171projiect;
 SamplingData=MyData;
Attri=[SamplingData(:,6)];
 XY=[SamplingData(:,2) SamplingData(:,3) ];
alpha1=90-59.2; 
alpha2=99-90; 
a=492590;%%main range
a1=492590;
b=336870;%%secondary range
d1=a1/b;
d2=a1/a;
tensileMatrix=[d2,0;0,d1];
Ashun1=[cosd(alpha2),sind(alpha2);-sind(alpha2),cosd(alpha2)];
Ani1=[cosd(alpha1),-sind(alpha1);sind(alpha1),cosd(alpha1)];
rotateXY1=XY*Ani1;
tensileXY=rotateXY1*tensileMatrix;
Ashun2=[cosd(alpha1),sind(alpha1);-sind(alpha1),cosd(alpha1)];
Ani2=[cosd(alpha2),-sind(alpha2);sind(alpha2),cosd(alpha2)];
rotateXY2=tensileXY*Ashun2;
rotatedAndTensiledData=[rotateXY2 Attri SamplingData(:,4)];