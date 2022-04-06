Methodology
Two-Stage Heuristic Algorithm based on Yang
Stage 1: Partition I entities (homes) into K clusters. Let [I_k] be the index set of entities in cluster k, k ∈ [K].
Stage 2: For each k ∈ [K], build a regression model using entities in [I_k].

# k-means cluster analysis
km = kmeans(house_train, centers = 10,  nstart = 25)
df = house_train %>%
  mutate(cluster = km$cluster)
# run lm on each cluters
fitted_models = df %>% 
  group_by(cluster) %>% 
  do(model = lm(medianHouseValue ~ . -longitude -latitude, data = .))
fitted_models

# test data 
house_test$cluster = predict(km, newdata = house_test)

for (i in 1:10){
  house_test$cluster[i] = predict(km, newdata = house_test[i,1:9])
}
for (row in 1:length(house_test$cluster[1:10])){
  n = house_test$cluster[row]
  yhat1 = predict(fitted_models$model[[n]], newdata = house_test[row,])
}

# mapping centers of each cluster
cluster_lon = km$centers[,1]
cluster_lat = km$centers[,2]
cluster_size = km$size
cluster_val = dollar(km$centers[,9])
cluster_info = data.frame(cbind(cluster_lon, cluster_lat, cluster_size, cluster_val)) %>%
  arrange(desc(cluster_val))

m2 = get_stamenmap(bbox = c(left = -127, bottom = 32, right = -112, top = 40),
                   maptype = "terrain",
                   color = "bw",
                   crop = FALSE,
                   zoom = 8)
library(gganimate)
ggmap(m2) + 
  geom_point(data = df, aes(x = longitude, y = latitude, color = as.factor(cluster), alpha = .7)) + 
  scale_color_viridis(discrete = TRUE, option = "plasma", labels = as.character(cluster_info$cluster_val)) +  
  transition_states(df$cluster, transition_length = 2, state_length = 1) + 
  shadow_mark() + 


# read in data 
data = read_csv(here(("data/greenbuildings.csv")), na = "NA", show_col_types = FALSE) %>%
  filter(net == 0) %>% 
  select(-cluster) %>%
  mutate(
    rev_psf = size*leasing_rate*Rent) # create revenue per sf per year variable
data = na.omit(data)
attach(data)

# K-means Cluster Analysis
set.seed(123)
data_split = initial_split(data, 0.8)
data_train = training(data_split)
data_test = testing(data_split)


# function to compute total within-cluster sum of square 
wss = function(k) {
  kmeans(data_train, k, nstart = 10 )$tot.withinss
}

# Compute and plot wss for k = 1 to k = 20
k.values = 1:20

# extract wss for 2-20 clusters
wss_values = map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")

kmeans = kmeans(data_train, centers = 10, nstart = 20)
kmeans

test_cl = cl_predict(kmeans, newdata = data_test)

# 
cl_data_train =  cbind(data_train, kmeans$cluster) %>%
  rename(
    "cluster" = "kmeans$cluster"
  )

# split data into clusters
df_clusters = split(cl_data_train, as.factor(cl_data_train$cluster))

# run lm regression on each cluster 
cluster_lm = lmList(rev_psf ~ . -CS_PropertyID -cluster | cluster, cl_data_train) %>%
  
  # fit out-of-sample data
  for (i in data_test){
    test_cl = cl_predict(kmeans, newdata = data_test[i,])
    lm = cluster_lm[which(cluster_lm$cluster == integer(test_cl))]
    predict(lm, newdata = data)
  }