ABIA_AA = read_csv(here(("data/ABIA.csv"))) %>%
  mutate(delay_total = ArrDelay - DepDelay,
         DayOfWeek = recode(DayOfWeek, 
                            "1"="Monday",
                            "2"="Tuesday",
                            "3"="Wednesday",
                            "4"="Thursday",
                            "5"="Friday",
                            "6"="Saturday",
                            "7"="Sunday"),
         DayOfWeek = fct_relevel(DayOfWeek, 
                                 "Monday", "Tuesday", "Wednesday", 
                                 "Thursday", "Friday", "Saturday", 
                                 "Sunday")) %>%
  filter(UniqueCarrier == "AA") %>%
  write_csv(here("data/ABIA_AA_clean.csv"))