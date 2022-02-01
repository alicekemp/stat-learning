billboard_unique = read_csv(here("data/billboard_clean.csv")) %>%
  group_by(performer, song, year) %>%
  filter(year != 1958, year != 2021) %>%
  unite("performer_song", performer:song, sep = " - ", remove = TRUE) %>%
  summarize(
            unique_songs = n_distinct(performer_song)) 

ggplot(billboard_unique, aes(x=year, y=unique_songs)) + 
  geom_line(color = "darkgrey") + 
  ylab("unique songs") + 
  ggtitle('Unique Billboard Top 100 songs by year') + 
  labs(caption = 'The number of unique songs on the Billboard Top 100 list peaked in the late 1960s, \n before dipping to a low in 2001. However, music diversity has risen again, with \n 2020 reaching 800 unique songs on the Top 100.') + 
  theme(
    plot.caption = element_text(hjust = 0)) %>%
ggsave(here("figures/billboard_unique_songs.png"), width=8, height=4.5)