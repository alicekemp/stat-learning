#### K-nearest neighbors
sclass350 = read_csv(here("data/sclass_clean.csv")) %>%
  filter(trim==350)

# create train/test splits
sclass350_split = initial_split(sclass350, prop = 0.8)
sclass350_train = training(sclass350_split)
sclass350_test = testing(sclass350_split)

# KNN models
rmse_out = foreach(i=2:100, .combine='c') %do% {
  # train the model and calculate RMSE on the test set
  knn_model = knnreg(price ~ mileage, data=sclass350_train, k = i)
  modelr::rmse(knn_model, sclass350_test)
} 

# plot K vs. RMSE
k_vals = seq(2,100,1)
df = data.frame(k_vals, rmse_out)
ggplot(df) + 
  geom_line(aes(x = k_vals, y = rmse_out), color = "steelblue3") + 
  xlab("K") + 
  labs(title = "K-Fold Cross Validation: K vs. RMSE") %>%
ggsave(here("figures/sclass350_rmse.png"), width=8, height=4.5)

# find optimal K (minimum RMSE) = 32
optimal_k = df %>%
  group_by(k_vals) %>%
  arrange(rmse_out)

# attach predictions to the test df
knn32 = knnreg(price ~ mileage, data=sclass350_train, k = 32)

sclass350_test = sclass350_test %>%
  mutate(price_pred = predict(knn32, sclass350_test))

ggplot(data = sclass350_test) + 
  geom_point(mapping = aes(x =  mileage, y = price), alpha=0.2) + 
  geom_line(aes(x = mileage, y = price_pred), color='steelblue3', size=1.5) +
  labs(
    title = "Mercedes S Class: Mileage vs. Price",
    subtitle = "Trim level: 350 | KNN Model (K=32)"
  )
ggsave(here("figures/sclass350_knnpred.png"), width=8, height=4.5)



