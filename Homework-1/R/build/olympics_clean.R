olympics = read_csv(here(("data/olympics_top20.csv"))) %>%
  write_csv(here("data/olympics_clean.csv"))