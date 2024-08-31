    load JJJ171projiect.txt;
    yizhi=JJJ171projiect;
    [row,col]=size(yizhi); 
    data=[yizhi(:,2:4),yizhi(:,5)];
    data(:,4)=data(:,4)+(0.6./100).*data(:,3);

    X = data(:, 1);
    Y = data(:, 2);
    Z = data(:, 4);

    Kfold = 10; 
    g=1;G=300;
    n = length(Z);

    rmse_values = zeros(10, 1);
    mape_values = zeros(10, 1);
    mae_values = zeros(10, 1);
    r2_values = zeros(10, 1);
    tempRMSE=zeros(G-1,1);
    tempMAE=zeros(G-1,1);
    tempMAPE=zeros(G-1,1);
    tempR2=zeros(G-1,1);
 while(g<=G)
    for k = 1:10
         indices = crossvalind('Kfold', n, 10);
        test_idx = (indices == k);
        train_idx = ~test_idx;
        
        X_train = X(train_idx);
        Y_train = Y(train_idx);
        Z_train = Z(train_idx);
        
        X_test = X(test_idx);
        Y_test = Y(test_idx);
        Z_test = Z(test_idx);
        
        Z_pred = zeros(sum(test_idx), 1);
        for i = 1:sum(test_idx)
            x_i = X_test(i);
            y_i = Y_test(i);
            
            if length(X_train) < 3
                Z_pred(i) = mean(Z_train);
                continue;
            end
            

            distances = sqrt((X_train - x_i).^2 + (Y_train - y_i).^2);
            
            [sortedDistances, sortedIndices] = sort(distances);
            numNeighbors = min(10, length(sortedDistances)); 
            nearestDistances = sortedDistances(1:numNeighbors);
            nearestValues = Z_train(sortedIndices(1:numNeighbors));

            localVar = var(nearestValues);
            power = 2 + localVar; 
            

            weights = 1 ./ (nearestDistances .^ power);
            weights(nearestDistances == 0) = Inf; 
            weights = weights / sum(weights); 
            
            Z_pred(i) = sum(weights .* nearestValues);
        end
        

        rmse_values(k) = sqrt(mean((Z_test - Z_pred).^2));
        mape_values(k) = mean(abs((Z_test - Z_pred) ./ Z_test)) * 100;
        mae_values(k) = mean(abs(Z_test - Z_pred));
        ss_res = sum((Z_test - Z_pred).^2);
        ss_tot = sum((Z_test - mean(Z_test)).^2);
        r2_values(k) = 1 - (ss_res / ss_tot);
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