capmetro_UT = read_csv(here(("data/capmetro_UT_clean.csv")))
order = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun") 
capmetro_UT %>%
  mutate(across(day_of_week, factor, levels = order)) %>%
  group_by(hour_of_day, day_of_week, month) %>%
  summarize(avg_boardings = mean(boarding)) %>%
ggplot(aes(x=hour_of_day,y=avg_boardings, color = month)) + 
  geom_line() + 
  facet_wrap(vars(day_of_week),nrow=2) + 
  scale_color_manual(values = c(plasma[7],plasma[5],plasma[3])) +
  my_theme
  