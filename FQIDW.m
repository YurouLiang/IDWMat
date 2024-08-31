
    load JJJ171projiect.txt;
    yizhi=JJJ171projiect;
    [row,col]=size(yizhi); 
    data=[yizhi(:,2:4),yizhi(:,5)];
    data(:,4)=data(:,4)+(0.6./100).*data(:,3);

    x = data(:, 1);
    y = data(:, 2);
    z = data(:, 4);
    k = 2; 
    p = 2; 
    Kfold = 10;
    g=1;G=300;
    n = length(z);


tempRMSE=zeros(G-1,1);
tempMAE=zeros(G-1,1);
tempMAPE=zeros(G-1,1);
tempR2=zeros(G-1,1);
    rmse_values = zeros(Kfold, 1);
    mape_values = zeros(Kfold, 1);
    mae_values = zeros(Kfold, 1);
    r2_values = zeros(Kfold, 1);
while(g<=G)   

    for fold = 1:Kfold
    indices = crossvalind('Kfold', n, 10);


   test_idx = (indices == fold);
        train_idx = ~test_idx;

        x_train = x(train_idx);
        y_train = y(train_idx);
        z_train = z(train_idx);

        x_test = x(test_idx);
        y_test = y(test_idx);
        z_test = z(test_idx);


        z_predicted = zeros(length(x_test), 1);
        for i = 1:length(x_test)
            z_predicted(i) = four_quadrant_idw(x_train, y_train, z_train, x_test(i), y_test(i), k, p);
        end

 
        rmse_values(fold) = sqrt(mean((z_test - z_predicted).^2));
        mape_values(fold) = mean(abs((z_test - z_predicted) ./ z_test)) * 100;
        mae_values(fold) = mean(abs(z_test - z_predicted));
        r2_values(fold) = 1 - sum((z_test - z_predicted).^2) / sum((z_test - mean(z_test)).^2);
    end
cross_val_errorsRMSE = mean(rmse_values);
cross_val_errorsMAE = mean(mae_values);
cross_val_errorsMAPE = mean(mape_values);
cross_val_errorsR2 = mean(r2_values);
tempRMSE(g)=cross_val_errorsRMSE;
tempMAE(g)=cross_val_errorsMAE;
tempMAPE(g)=cross_val_errorsMAPE;
tempR2(g)=cross_val_errorsR2;
g=g+1;

end


    fprintf('RMSE: %.4f\n', min(tempRMSE));
    fprintf('MAPE: %.4f%%\n', min(tempMAPE));
    fprintf('MAE: %.4f\n', min(tempMAE));
    fprintf('R²: %.4f\n', min(tempR2));

function z_interp = four_quadrant_idw(x, y, z, xi, yi, k, p)


    distances = sqrt((x - xi).^2 + (y - yi).^2);
    [sorted_distances, idx] = sort(distances);
    nearest_distances = sorted_distances(1:min(k, length(sorted_distances)));
    nearest_values = z(idx(1:min(k, length(sorted_distances))));
    weights = 1 ./ (nearest_distances .^ p);
    z_interp = sum(weights .* nearest_values) / sum(weights);
end

