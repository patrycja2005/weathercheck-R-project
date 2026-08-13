
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


wc %>% 
  filter(!is.na(age)) %>% 
  filter(ck_weather == 'yes') %>%
           group_by( age ) %>% 
           summarise( n=n() )


# żródło by wiek

wc %>%
  filter( !is.na(age)) %>% 
  ggplot( aes( x = age, 
               fill = weather_source)) +
  geom_bar() +
  labs(title = "W jaki sposób zazwyczaj sprawdzasz pogodę?",
       subtitle= "według wieku",
       x = "", 
       y = "", 
       fill = "Weather source")+
  facet_wrap(~weather_source, scales = "free_x", ncol = 2)+
  theme_minimal()+
  theme(legend.position = "none")


# Gdybyś posiadał(a) smartwatcha, jak prawdopodobne jest, że sprawdzał(a)byś na nim pogodę?
wc %>%
  filter( !is.na( ck_weather_watch)) %>%
  count( ck_weather_watch) %>%
  ggplot (aes (y = ck_weather_watch, x = n )) +
  geom_col( fill = "steelblue1", color = "white", width = 0.6) +
  geom_text( aes( label = n), hjust = -0.3, size = 3) +
  xlab("") +
  ylab("") +
  labs(title = "Gdybyś posiadał(a) smartwatcha, jak prawdopodobne jest, \n że sprawdzał(a)byś na nim pogodę?") +
  xlim(c(0,400))+
  theme_minimal()+
  theme(plot.title = element_text(size = 10))


# Gdybyś posiadał(a) smartwatcha, jak prawdopodobne jest, \n że sprawdzał(a)byś na nim pogodę? według wieku
wc %>%
  filter( !is.na( ck_weather_watch)) %>%
  filter( !is.na(age)) %>% 
  ggplot( aes(x= age, fill = ck_weather_watch))+
  geom_bar( position = "dodge", color= "white")+
  labs( x= "",
        y= "",
        title = "Gdybyś posiadał(a) smartwatcha, jak prawdopodobne jest, \n że sprawdzał(a)byś na nim pogodę?",
        subtitle = "według wieku",
        fill= "How likely?")+
  theme(plot.title = element_text( hjust = 0.2, size = 12))+
  theme_minimal()


# Stosunek do smartwatchy a dochód gospodarstwa domowego

wc %>% 
  filter(!is.na(hhold_income), !is.na(ck_weather_watch)) %>% 
  ggplot(aes(x = hhold_income, fill = ck_weather_watch)) +
  geom_bar(position = "fill") + # Paski skumulowane do 100%
  scale_y_continuous(labels = scales::percent) +
  coord_flip() +
  labs(title = "Stosunek do smartwatchy a dochód gospodarstwa domowego",
       x = "", y = "Procent odpowiedzi", fill = "Odpowiedź") +
  theme_minimal()

# 1) Przygotowanie danych (usunięcie braków danych NA)
dane_test <- wc %>% 
  filter(!is.na(hhold_income), !is.na(ck_weather_watch))

# 2) Utworzenie tabeli
tabela_krzyzowa <- table(dane_test$hhold_income, dane_test$ck_weather_watch)

# 3) Wykonanie testu Chi-kwadrat
test_chi2 <- chisq.test(tabela_krzyzowa)

# 4) Wyświetlenie wyników testu
test_chi2
