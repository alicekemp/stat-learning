ABIA_AA = read_csv(here("data/ABIA_AA_clean.csv"))

gganim2 = ggplot(ABIA_AA, aes(x=DepTime, y=delay_total, size = Distance, color = DayOfWeek)) +
  geom_point(aes(group=DepTime, alpha=0.7)) +
  scale_color_discrete(type = plasma) + 
  ylim(-50,150) +
  transition_states(DayOfWeek,transition_length = 1, state_length = 1) + 
  enter_fade() + 
  exit_fade() + 
  ease_aes("linear") + 
  ggtitle('Net delay vs. Departure time', subtitle = 'Day of Week: {closest_state}') + 
  xlab("Departure Time (hhmm)") + 
  ylab("Net Delay (min)")

future::plan("multicore", workers = 4L)

animate(gganim2)

anim_save("AA_delays_by_day.gif", path = "figures")