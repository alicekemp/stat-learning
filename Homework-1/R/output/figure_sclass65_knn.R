#### K-nearest neighbors
sclass65 = read_csv(here("data/sclass_clean.csv")) %>%
  filter(trim=="65 AMG")

# create train/test splits
sclass65_split = initial_split(sclass65, prop = 0.8)
sclass65_train = training(sclass65_split)
sclass65_test = testing(sclass65_split)

# KNN models
rmse_out = foreach(i=2:100, .combine='c') %do% {
  # train the model and calculate RMSE on the test set
  knn_model = knnreg(price ~ mileage, data=sclass65_train, k = i)
  modelr::rmse(knn_model, sclass65_test)
} 

# plot K vs. RMSE
k_vals = seq(2,100,1)
df = data.frame(k_vals, rmse_out)
ggplot(df) + 
  geom_line(aes(x = k_vals, y = rmse_out), color = "steelblue3") + 
  xlab("K") + 
  labs(title = "K-Fold Cross Validation: K vs. RMSE") %>%
  ggsave(here("figures/sclass65_rmse.png"), width=8, height=4.5)

# find optimal K (minimum RMSE) = 10
optimal_k = df %>%
  group_by(k_vals) %>%
  arrange(rmse_out)

# attach predictions to the test df
knn10 = knnreg(price ~ mileage, data=sclass65_train, k = 10)

sclass65_test = sclass65_test %>%
  mutate(price_pred = predict(knn10, sclass65_test))

ggplot(data = sclass65_test) + 
  geom_point(mapping = aes(x =  mileage, y = price), alpha=0.2) + 
  geom_line(aes(x = mileage, y = price_pred), color='steelblue3', size=1.5) +
  labs(
    title = "Mercedes S Class: Mileage vs. Price",
    subtitle = "Trim level: 65 AMG | KNN Model (K=10)"
  )
ggsave(here("figures/sclass65_knnpred.png"), width=8, height=4.5)



