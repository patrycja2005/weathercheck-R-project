
# 1. Wczytanie wymaganych bibliotek ============================================

library(fivethirtyeight) 
library(tidyverse)       

?weather_check

# Wczytanie danych
wc <- weather_check

str(wc)     # Wyświetla strukturę ramki danych
summary(wc) # Podstawowe statystyki opisowe


# 2. Przygotowanie =============================================================


# Tworzenie nowej zmiennej 'sex' na podstawie kolumny 'female'
wc$sex <- factor(
  ifelse( is.na( wc$female), "not given",
          ifelse( wc$female == TRUE, "Female", 
                  "Male") ),
  levels = c("Male", "Female", "not given")
)

# Rekodowanie zmiennej 'ck_weather' 
wc$ck_weather <- factor(wc$ck_weather,
                        levels = c(TRUE, FALSE),
                        labels = c("yes", "no"))

# Konwersja zmiennej dotyczącej korzystania ze smartwatcha
wc$ck_weather_watch <- factor(wc$ck_weather_watch)


# 3. Wykresy ===================================================================

## Czy zazwyczaj sprawdzasz codzienną prognozę pogody? podział na płeć ---------
wc %>% 
  ggplot(aes(x = ck_weather, fill = sex)) +
  geom_bar(color = "white",
           position = "dodge",
           width = 0.6) +
  geom_text(stat = "count", 
            aes(label = after_stat(count)), 
            position = position_dodge(width = 0.6), 
            vjust = -0.5, 
            size = 3) +
  scale_fill_manual(values = c( 
    "Female" = "lightpink2", 
    "Male" = "lightblue",
    "not given" = "grey")) +
  xlab("") + ylab("") +
  ggtitle("Czy zazwyczaj sprawdzasz codzienną prognozę pogody?") +
  theme_minimal()



## Osoby zazwyczaj sprawdzające codzienną prognozę pogody Według regionu -------
wc %>% 
  filter(ck_weather == 'yes') %>%
  filter(!is.na(region)) %>% 
  count( region) %>% 
  ggplot( aes(y = reorder(region, n), x=n, fill= n)) + 
  geom_col( 
    color= "white")+
  geom_text( aes( label = n),
             hjust = -0.2, 
             size = 3)+
  scale_fill_gradient(high ="#3CB371",low="lightgoldenrod1")+
  labs(x="",
       y= "",
       title="Osoby zazwyczaj sprawdzające codzienną prognozę pogody",
       subtitle = "Według regionu")+
  theme_minimal()+
  theme(plot.title = element_text( hjust = -0.5, size = 13), 
        legend.position = "none")

## Osoby zazwyczaj sprawdzające codzienną prognozę pogody Według wieku ---------
wc %>% 
  filter(ck_weather == 'yes') %>%
  filter(!is.na(age)) %>% 
  count( age) %>% 
  ggplot( aes(x = reorder(age, -n), y=n, fill= n)) + 
  geom_col( 
    fill= "#8867A1")+
  geom_text( aes( label = n),
             size = 3, 
             vjust = -0.5)+
  labs(x="",
       y= "",
       title="Osoby zazwyczaj sprawdzające codzienną prognozę pogody",
       subtitle = "Według wieku")+
  theme_minimal()+
  theme(legend.position = "none")
