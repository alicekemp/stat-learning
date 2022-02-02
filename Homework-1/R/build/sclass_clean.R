sclass = read_csv(here(("data/sclass.csv"))) %>%
  select(trim, mileage, price) %>%
  filter(trim %in% c(350,"65 AMG")) %>%
  write_csv(here("data/sclass_clean.csv")) 