tic
load JJJ171projiect.txt;
yizhi=JJJ171projiect;
[row,col]=size(yizhi); 
data=[yizhi(:,2:4),yizhi(:,16)];
data(:,4)=data(:,4)+(0.6./100).*data(:,3);
K=10;N=15;a=2;g=1;G=5;
validation_errorsRMSE = zeros(K, 1);
validation_errorsMAE = zeros(K, 1);
validation_errorsMAX= zeros(K, 1);
validation_errorsMIN = zeros(K, 1);
tempRMSE=zeros(G-1,1);
tempMAE=zeros(G-1,1);
tempMAX=zeros(G-1,1);
tempMIN=zeros(G-1,1);
predicted_valueall = [];
while(g<G)
    for i = 1 : K
    indices = crossvalind('Kfold', row, K);
     testIdx= (indices == i);
     trainIdx= ~testIdx;
     traindata=data(trainIdx,:);
     textdata=data(testIdx,:);
     predicted_values = zeros(length(textdata), 1);
     for t = 1:length(textdata)
         test_point = textdata(t, :);
         dis=pdist2(traindata(:,1:2),test_point(:,1:2));
         [dis,j]=sort(dis);
         dis=dis(1:N);
         j=j(1:N);
         f=traindata(j,4);
         Dis=dis.^-a;
         sm=sum(Dis);
         predicted_values(t)=sum(Dis.*f)./sm; 
     end
     validation_errorsRMSE(i) = sqrt(mean((textdata(:,4) -  predicted_values).^2));
     validation_errorsMAE(i)=mean(abs(textdata(:,4) -  predicted_values));
     validation_errorsMAX(i)=max(abs(textdata(:,4) -  predicted_values));
     validation_errorsMIN(i)=min(abs(textdata(:,4) -  predicted_values));
     validation_errorsMAPE(i) = mean(abs((textdata(:,4) - predicted_values) ./ textdata(:,4))) * 100;
     validation_R2(i) = 1 - sum((textdata(:,4) - predicted_values).^2) / sum((textdata(:,4) - mean(textdata(:,4))).^2);

    end
cross_val_errorsRMSE = mean(validation_errorsRMSE);
cross_val_errorsMAE = mean(validation_errorsMAE);
cross_val_errorsMAX = mean(validation_errorsMAX);
cross_val_errorsMIN = mean(validation_errorsMIN);
cross_val_errorsMAPE = mean(validation_errorsMAPE);
cross_val_errorsR2 = mean(validation_R2);
tempRMSE(g)=cross_val_errorsRMSE;
tempMAE(g)=cross_val_errorsMAE;
tempMAX(g)=cross_val_errorsMAX;
tempMIN(g)=cross_val_errorsMIN;
tempMAPE_idw(g)=cross_val_errorsMAPE;
tempR2(g)=cross_val_errorsR2;
g=g+1;
end
RMSE=min(tempRMSE);
MAE=min(tempMAE);
MAX=min(tempMAX);
MIN=min(tempMIN);
MAPE=min(tempMAPE_idw);
R2=min(tempR2);
% 打印结果
fprintf('RMSE: %.4f\n', RMSE);
fprintf('MAPE: %.4f%%\n',MAPE);
fprintf('MAE: %.4f\n', MAE);
fprintf('R²: %.4f\n', R2);


