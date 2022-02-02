sclass350 = read_csv(here(("data/sclass.csv"))) %>%
  select(trim, mileage, price) %>%
  filter(trim == 350) %>%
  write_csv(here("data/sclass350_clean.csv")) 

sclass65 = read_csv(here(("data/sclass.csv"))) %>%
  select(trim, mileage, price) %>%
  filter(trim == 65) %>%
  write_csv(here("data/sclass65_clean.csv")) 