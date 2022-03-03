if (!("librarian" %in% rownames(utils::installed.packages()))) {
  utils::install.packages("librarian")
}
librarian::shelf(
  tidyverse,
  lubridate,
  dplyr,
  haven, 
  stargazer, 
  RColorBrewer,
  here,
  ggmap,
  scales, 
  ggridges,
  viridis,
  gganimate, 
  gifski, 
  future, 
  geosphere,
  maps, 
  airportr, 
  kable, 
  kableExtra,
  rsample,
  caret,
  modelr,
  parallel,
  foreach)
## color palette brewing
plasma = c("darkorange2", "coral2", "orangered2", "violetred2", "magenta4", "purple3", "mediumblue")
## my theme

my_theme = theme_minimal(base_family = "Arial Narrow", base_size = 12) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = rel(1.7)),
        plot.subtitle = element_text(face = "plain", size = rel(1.3), color = "grey70"),
        plot.caption = element_text(face = "italic", size = rel(0.7), 
                                    color = "grey70", hjust = 0),
        legend.title = element_text(face = "bold"),
        strip.text = element_text(face = "bold", size = rel(1.1), hjust = 0),
        axis.title = element_text(face = "bold"),
        axis.title.x = element_text(margin = margin(t = 10), hjust = 0),
        axis.title.y = element_text(margin = margin(r = 10), hjust = 1))
here::i_am("R/include.R")