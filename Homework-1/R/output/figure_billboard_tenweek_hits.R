read_csv(here("data/billboard_clean.csv")) %>%
  group_by(performer, song) %>%
  summarize(
    nweeks = n()) %>%
  filter(
    nweeks>=10,
    ) %>%
  group_by(performer) %>%
  summarize(nsongs = n()) %>%
  filter(nsongs >= 30) %>%
ggplot(aes(x=reorder(performer, +nsongs), y=nsongs)) + 
  geom_col(fill = "steelblue3") + 
  ylab("Ten Week Songs (>30)") + 
  xlab("") + 
  ggtitle('Billboard 100 Ten-Week Artists') + 
  coord_flip() 
 ggsave(here("figures/billboard_tenweek_artists.png"), width=8, height=4.5)

