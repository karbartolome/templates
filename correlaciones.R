library(corrr)
library(kableExtra)
library(dplyr)

UMBRAL_SUPERIOR=0.9
UMBRAL_INFERIOR=0.5

df = iris %>% 
  mutate(Sepal.Length_neg= Sepal.Length*(-2)+Petal.Length)

corr_df <- correlate(df %>% select(-Species))
corr_df %>% select_if(~any(. >= UMBRAL_SUPERIOR | .<=-UMBRAL_INFERIOR))


corr_df %>% 
  select_if(~any(. >= UMBRAL_SUPERIOR | .<=-UMBRAL_INFERIOR)) %>% 
  mutate(across(where(is.numeric), ~tidyr::replace_na(., 1))) %>% 
  mutate(across(where(is.numeric), ~round(.,3))) %>% 
  mutate(across(where(is.numeric), ~cell_spec(., "html", 
                                              color = ifelse(. >= UMBRAL_SUPERIOR & .!=1, "blue", 
                                                             ifelse(. <= -UMBRAL_INFERIOR, "red", "black"))
  ))) %>%
  mutate(across(where(is.character), ~ifelse(.=='<span style=" color: black !important;" >99</span>',
                                             '<span style=" color: black !important;" >1</span>',.))) %>% 
  kable(escape=FALSE) %>%
  kable_styling("striped", full_width = FALSE)



