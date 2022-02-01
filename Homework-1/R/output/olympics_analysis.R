### Wrangling the Olympics
olympics_female = read_csv(here("data/olympics_clean.csv")) %>%
  filter(sex=="F") 


# (A) 95th percentile height is 186 cm for females
perc95 = quantile(olympics_female$height, 0.95)
perc95 

# (B) Greatest variation in height is in Women's Coxed Fours Rowing
olympics_female %>%
  group_by(event) %>%
  summarize(
    sd = sd(height)) %>%
  arrange(desc(sd))

# (C) 
swim_avgage_df = data.frame(read_csv(here("data/olympics_clean.csv")) %>%
  filter(sport == "Swimming") %>%
  group_by(year) %>%
  summarize(avg_age = mean(age)) %>%
  mutate(across(where(is.numeric), ~ round(., 1))))

# Split by gender
read_csv(here("data/olympics_clean.csv")) %>%
  filter(sport == "Swimming") %>%
  group_by(year, sex) %>%
  summarize(avg_age = mean(age)) %>%
ggplot(aes(x=year,y=avg_age, color = sex)) + 
  geom_line() +
  geom_line(data = swim_avgage_df, aes(x=year,y=avg_age, color = "darkgrey"), linetype = "dotted", inherit.aes=FALSE) + 
  scale_color_manual(values = c("M" = "steelblue3",
                                "F"="red3")) + 
  labs(title = "Average Age of Olympic Swimmers over Time",
       caption = "After peaking in 1924, the average age of olympics swimmers has increased over \n time, with female swimmers being younger than male swimmers on average.") +
  ylab("average age") + 
  theme(
    plot.caption = element_text(hjust = 0)) %>%
ggsave(here("figures/olympics_avgage_swimming.png"), width=8, height=4.5)
  

  
  