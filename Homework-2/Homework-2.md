# Problem 1: Capmetro UT Visualization

    capmetro_UT = read_csv(here(("data/capmetro_UT_raw.csv"))) 

    ## Rows: 5824 Columns: 8
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (3): day_of_week, month, weekend
    ## dbl  (4): boarding, alighting, temperature, hour_of_day
    ## dttm (1): timestamp
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    capmetro_UT %>%
      mutate(across(day_of_week, factor, levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")),
             across(month, factor, levels = c("Sep", "Oct", "Nov"))) %>%
      group_by(hour_of_day, day_of_week, month) %>%
      summarize(avg_boardings = mean(boarding)) %>%
    ggplot(aes(x=hour_of_day,y=avg_boardings, color = month)) + 
      geom_line() + 
      facet_wrap(vars(day_of_week),nrow=2) + 
      scale_color_manual(values = c("steelblue1", "royalblue1", "mediumblue")) +
      my_theme + 
      ggtitle("Capmetro UT average boardings",
              subtitle = "Passenger demand is highest on weekdays and peaks during the evening between 4:00 and 6:00 pm") + 
      labs(
        xlab("Hour of Day"),
        ylab("Average Boardings")
      )

    ## `summarise()` has grouped output by 'hour_of_day', 'day_of_week'. You can
    ## override using the `.groups` argument.

![](Homework-2_files/figure-markdown_strict/unnamed-chunk-1-1.png)

    capmetro_UT %>%
      separate(col = timestamp, into = c("date", "hourwindow"), sep = "\\ ") %>%
      group_by(temperature, weekend) %>%
    ggplot(aes(x=temperature,y=boarding, color = weekend)) + 
      geom_point(alpha = 0.6, size = 0.9) + 
      facet_wrap(vars(hour_of_day),nrow=4) + 
      scale_color_manual(values=c("steelblue2","mediumblue")) + 
      my_scatter_theme + 
      ggtitle("Temperature vs. Capmetro UT boardings by hour",
              subtitle = "Passenger demand is higher on weekdays, peaking during evening commute periods. \n Temperature appears to have little impact on number of passenger boardings") + 
      labs(
        x = "Temperature (°F)",
        y = "Total Boardings"
      )

![](Homework-2_files/figure-markdown_strict/unnamed-chunk-2-1.png)

# Problem 2: Saratoga house prices

## Data

The dataset used in this report covers housing prices and 15
characteristics for over 1,700 houses in the Saratoga County, Florida
residential market in the year 2006. Characteristics include lot size,
age, land value, living area, percent of neighborhood that graduated
college, bedrooms, fireplaces, bathrooms, rooms, type of heating, type
of fuel used for heating, type of sewer system, and whether the property
was waterfront, new construction, and had central air conditioning. To
better compare performance across models, the categorical variables were
converted to binary dummy variables. The data was then normalized in
order to build the K-nearest neighbors model.

## Methodology

To analyze the effects of house features on a home’s sale price, four
models of varying complexity were created. The first two baseline models
utilized simple linear OLS regressions of price on a selection of home
features, with the “big” OLS model including interaction effects of all
included features. The data was also randomized into train/test splits
with an 80% training proportion to build and evaluate model performance.
The next model utilized a LASSO model for feature selection. All
features and their interactions were included, and k-fold cross
validation (K = 10) was performed to minimize the risk of overfitting
the sample data. Finally, a K-nearest neighbors model was run and
iterated over 100 values of K to identify the final model. This KNN
model also iterated over K-10 folds for cross validation purposes.

## Technical Notes

To compare out-of-sample performance across models, the RMSE was
calculated for each regression for the test set and an average RMSE was
calculated as the mean out-of-sample RMSE across folds for the
cross-validated LASSO and KNN models. For the two baseline OLS models,
the big model which included most interaction terms performed better
than the medium model with an out-of-sample RMSE of approximately 0.649
compared to 0.704. The cross-validated LASSO regression outperformed all
other models, yielding an out-of-sample RMSE of approximately 0.554. In
the LASSO model, coefficient shrinkage was performed on all possible
interactions of all factor levels and features, while the KNN model
utilized group patterns in the training data to classify the test data.

## Conclusion

Overall, the cross-validated LASSO model performed the best out of the
four regressions, with normalized out-of-sample error of about 0.55. To
best predict housing prices based on the variables included in this
study, we recommend using the LASSO model. This model not only has a
lower error than the other models, but also identifies the most
important features and interactions that impact property prices. The
features identified in this model are lot size, land value, living area,
number of bathrooms, waterfront property, and central air systems. The
most important interactions include septic sewer systems based on
property age, land value based on new construction status, and living
area based on central air status.

    ##                 rmse
    ## rmse_med   0.7036676
    ## rmse_big   0.6489058
    ## rmse_lasso 0.5537551
    ## rmse_knn   0.6448680

# Problem 3: Classification and retrospective sampling

## Data

This analysis investigates credit default history of 1,000 customers of
a German bank. The data was sampled retrospectively, with the relatively
small sample of defaulted loans matched with a similar set of loans that
did not default. This sampling resulted in an outsized representation of
defaults relative to a random sample of the bank’s population of loans.
Variables of interest studied in this analysis include loan duration,
loan amount, installment amount, consumer age, consumer credit history,
loan purpose, and a dummy variable for foreign workers. In this
analysis, we attempt to predict a consumer’s probability of default
based on features deemed statistically significant.

## Methodology

The data was grouped by credit history, with three bins diving consumers
by “terrible”, “poor”, and “good” prior credit history. Then,
probability of default was calculated for each group by summing the
number of defaulted loans and dividing by the number of consumers per
credit group. From the figure shown, we observe that individuals with
good credit history have a high probability of defaulting on a loan at
approximately 60%, compared to 32% for consumers with “poor” credit and
18% for “terrible” credit history.

## Evalutation

Looking at the above probabilities, it is clear that the method of
retrospective sampling may have introduced some bias in the data
analyzed in this report. Upon closer investigation, we find that
consumers with “good” credit account for only 9% of the individuals
included in the study, while those with “poor” and “terrible” credit
make up 62% and 29%, respectively. Therefore, we observe evidence of
sampling selection bias in the data points included in this analysis,
with a potentially unrepresentative sample fo defaults from “good”
credit individuals than would appear in a random sample. To improve this
analysis’ predictive power in predicting a bank customer’s probability
of default, we recommend resampling the data to include a balanced panel
of individuals across credit histories, or a larger random sample of
loans irrespective of default status to gather data that is more
representative of the population.

    ## Warning: Ignoring unknown parameters: face

![](Homework-2_files/figure-markdown_strict/unnamed-chunk-4-1.png)

    ## 
    ## Call:
    ## glm(formula = Default ~ duration + amount + installment + age + 
    ##     history + purpose + foreign, family = binomial(link = "logit"), 
    ##     data = german_credit)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.3464  -0.8050  -0.5751   1.0250   2.4767  
    ## 
    ## Coefficients:
    ##                       Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)         -7.075e-01  4.726e-01  -1.497  0.13435    
    ## duration             2.526e-02  8.100e-03   3.118  0.00182 ** 
    ## amount               9.596e-05  3.650e-05   2.629  0.00856 ** 
    ## installment          2.216e-01  7.626e-02   2.906  0.00366 ** 
    ## age                 -2.018e-02  7.224e-03  -2.794  0.00521 ** 
    ## historypoor         -1.108e+00  2.473e-01  -4.479 7.51e-06 ***
    ## historyterrible     -1.885e+00  2.822e-01  -6.679 2.41e-11 ***
    ## purposeedu           7.248e-01  3.707e-01   1.955  0.05058 .  
    ## purposegoods/repair  1.049e-01  2.573e-01   0.408  0.68346    
    ## purposenewcar        8.545e-01  2.773e-01   3.081  0.00206 ** 
    ## purposeusedcar      -7.959e-01  3.598e-01  -2.212  0.02694 *  
    ## foreigngerman       -1.265e+00  5.773e-01  -2.191  0.02849 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1221.7  on 999  degrees of freedom
    ## Residual deviance: 1070.0  on 988  degrees of freedom
    ## AIC: 1094
    ## 
    ## Number of Fisher Scoring iterations: 4

# Problem 4: Children and hotel reservations

## Model building

    library(pROC)

    ## Type 'citation("pROC")' for a citation.

    ## 
    ## Attaching package: 'pROC'

    ## The following object is masked from 'package:gmodels':
    ## 
    ##     ci

    ## The following objects are masked from 'package:mosaic':
    ## 
    ##     cov, var

    ## The following objects are masked from 'package:stats':
    ## 
    ##     cov, smooth, var

    hotels = read_csv(here(("data/hotels_dev_raw.csv")))

    ## Rows: 45000 Columns: 22

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr   (9): hotel, meal, market_segment, distribution_channel, reserved_room_...
    ## dbl  (12): lead_time, stays_in_weekend_nights, stays_in_week_nights, adults,...
    ## date  (1): arrival_date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    set.seed(13)
    hotels_split = initial_split(hotels, 0.8)
    hotels_train = training(hotels_split)
    hotels_test = testing(hotels_split)

    baseline1 = glm(children ~ market_segment + adults + customer_type + is_repeated_guest, family = "binomial"(link = 'logit'), data = hotels_train)

    baseline2 = glm(children ~ . -arrival_date, family = "binomial"(link = 'logit'), data = hotels_train)

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    x_train = model.matrix(children ~ .-1, data = hotels_train)
    y_train = hotels_train$children
    x_test = model.matrix(children ~ .-1, data = hotels_test)
    y_test = hotels_test$children
    lasso_cv = cv.glmnet(x_train, y_train, type.measure = "mse", alpha = 1, nfolds = 10, family = "binomial") 
    lasso_predict = predict(lasso_cv, s = 'lambda.min', newx = x_test, alpha = 1, type = "response", family = "binomial"(link='logit'))
    rmselasso = sqrt(mean((y_test-lasso_predict)^2)) 

    rmse(baseline1, hotels_test)

    ## [1] 3.107264

    rmse(baseline2, hotels_test)

    ## [1] 4.101296

    rmselasso

    ## [1] 0.2267663

    library(pROC)
    proc = roc(y_test ~ lasso_predict, plot = TRUE, print.auc=TRUE, col = "mediumblue", lwd =4, main = "ROC Curve", print.thres = TRUE)

    ## Setting levels: control = 0, case = 1

    ## Warning in roc.default(response, predictors[, 1], ...): Deprecated use a matrix
    ## as predictor. Unexpected results may be produced, please pass a numeric vector.

    ## Setting direction: controls < cases

![](Homework-2_files/figure-markdown_strict/unnamed-chunk-5-1.png)

    ### Model Validation
    hotels_val = read_csv(here(("data/hotels_val_raw.csv")))

    ## Rows: 4999 Columns: 22
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr   (9): hotel, meal, market_segment, distribution_channel, reserved_room_...
    ## dbl  (12): lead_time, stays_in_weekend_nights, stays_in_week_nights, adults,...
    ## date  (1): arrival_date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    library(naivebayes)

    ## naivebayes 0.9.7 loaded
    ## 
    ## Attaching package: 'naivebayes'
    ## 
    ## The following object is masked from 'package:data.table':
    ## 
    ##     tables

    trctrl = trainControl(method = "cv", number = 20, savePredictions=TRUE)
    nb_fit = train(factor(children) ~ market_segment + adults + customer_type + is_repeated_guest, data = hotels_val, method = "naive_bayes", trControl=trctrl, tuneLength = 0)
    nb_fit

    ## Naive Bayes 
    ## 
    ## 4999 samples
    ##    4 predictor
    ##    2 classes: '0', '1' 
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (20 fold) 
    ## Summary of sample sizes: 4750, 4748, 4749, 4749, 4749, 4749, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   usekernel  Accuracy   Kappa     
    ##   FALSE      0.5141140  0.07002745
    ##    TRUE      0.9195853  0.00000000
    ## 
    ## Tuning parameter 'laplace' was held constant at a value of 0
    ## Tuning
    ##  parameter 'adjust' was held constant at a value of 1
    ## Accuracy was used to select the optimal model using the largest value.
    ## The final values used for the model were laplace = 0, usekernel = TRUE
    ##  and adjust = 1.

    pred = nb_fit$pred
    pred$equal = ifelse(pred$pred == pred$obs, 1,0)
    eachfold = pred %>%                                        
      group_by(Resample) %>%                         
      summarise_at(vars(equal),                     
                   list(Accuracy = mean))  
    avg_acc = mean(eachfold$Accuracy)
    df = rbind(data.frame(eachfold), avg_acc)
    df[21,1] = "Average"
    colnames(df) = c("Fold", "Accuracy")
    df

    ##       Fold  Accuracy
    ## 1   Fold01 0.7228916
    ## 2   Fold02 0.7250996
    ## 3   Fold03 0.6920000
    ## 4   Fold04 0.7080000
    ## 5   Fold05 0.7080000
    ## 6   Fold06 0.7080000
    ## 7   Fold07 0.7320000
    ## 8   Fold08 0.6852590
    ## 9   Fold09 0.7660000
    ## 10  Fold10 0.7329317
    ## 11  Fold11 0.7460000
    ## 12  Fold12 0.6960000
    ## 13  Fold13 0.7080000
    ## 14  Fold14 0.7720000
    ## 15  Fold15 0.7080000
    ## 16  Fold16 0.7400000
    ## 17  Fold17 0.7028112
    ## 18  Fold18 0.6800000
    ## 19  Fold19 0.7120000
    ## 20  Fold20 0.6920000
    ## 21 Average 0.7168497
