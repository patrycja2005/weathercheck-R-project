library(fivethirtyeight)
library(tidyverse)

?weather_check

wc <- weather_check

str(wc)
summary(wc)

wc$sex <- factor(
  ifelse( is.na( wc$female), "not given",
          ifelse( wc$female == TRUE, "Female", 
                  "Male") ),
  levels = c("Male", "Female", "not given")
)


wc$ck_weather <- factor(wc$ck_weather,
                        levels = c(TRUE, FALSE),
                        labels = c("yes", "no"))

wc$ck_weather_watch <- factor(wc$ck_weather_watch)



# czy sprawdzasz pogode
wc %>% 
  group_by(ck_weather, sex) %>% 
  summarise(n=n()) %>% 
  pivot_wider(names_from = ("ck_weather"), values_from = ("n"))



wc %>%
  group_by(ck_weather, sex) %>%
  summarise(n = n(), .groups = "drop") %>%
  pivot_wider(names_from = ck_weather, values_from = n) %>%
  rowwise() %>%
  mutate(Total = sum(c_across(where(is.numeric)), na.rm = TRUE)) %>%
  ungroup()


# czy sprawdzasz pogode? podział na płeć
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



# jak sprawdzasz pogode
wc %>% 
  filter(!is.na(weather_source)) %>%  
  group_by(weather_source) %>% 
  summarise(
    count = n(),
    percent = round(n() / nrow(wc) * 100, 2)  
  ) %>%
  arrange(desc(percent))




# jak często sprawdzasz pogode na smartwachu 
wc %>% 
  group_by(ck_weather_watch) %>% 
  summarise( n=n()) %>% 
  arrange(desc(n))

wc %>%
  filter( !is.na( ck_weather_watch)) %>%
  count( ck_weather_watch) %>%
  ggplot (aes (y = ck_weather_watch, x = n )) +
  geom_col( fill = "steelblue1", color = "white", width = 0.6) +
  geom_text( aes( label = n), hjust = -0.3, size = 3.5) +
  xlab("") +
  ylab("") +
  ggtitle("If you had a smartwatch, how likely would you be to check the weather on that device?") +
  theme(plot.title = element_text( hjust = 1.1, size = 13))+
  xlim(c(0,400))



# żródło by wiek
wc %>%
  filter( !is.na(age)) %>% 
  ggplot( aes( x = age, 
               fill = weather_source)) +
  geom_bar() +
  labs(title = "Weather source by age",
       x = "Age", 
       y = "Number of people", 
       fill = "Weather source")+
  facet_wrap(~weather_source, scales = "free_x", ncol = 2)+
  theme(legend.position = "none")

wc %>%
  filter( !is.na(age)) %>% 
  group_by( weather_source, age ) %>% 
  summarise(n=n() ) %>% 
  pivot_wider(  names_from = age, values_from = n )

# liczebność w regione 
wc %>% 
  group_by(region, ck_weather) %>% 
  summarise(n=n()) %>% 
  pivot_wider(names_from = ck_weather, values_from = n)




# przyjmujemy H0: zmienne są niezależne 
#             H1: zmienne są zależne 

# poetem patrzymy na p-value 
# jak wychodzi mniejsze od alfy (0.05) -- biorę H1


# chi kwadrat dla wieku i żródła 
ch1 <- chisq.test(wc$weather_source, wc$age)

ch1$statistic
ch1$p.value 

res_df1 <- as.data.frame( as.table( ch1$stdres ))

colnames(res_df1) <- c("weather_source", "age", "std_resid")

res_df1 %>% 
  ggplot( aes(x= age, y=weather_source, fill=std_resid) )+
  geom_tile()+
  geom_text( aes( label = round(std_resid, 1)), size = 3) +
  scale_fill_gradient2(low = "#0000CD", mid = "white", high = "firebrick2", midpoint = 0) +
  labs(
    title = "Chi-squared standardized residuals",
    x = "Smartwatch likelihood",
    y = "Weather source",
    fill = "Residual"
  ) +
  theme_minimal()


# chi kwadrat dla dochodu i żródła 
ch2 <- chisq.test(wc$weather_source, wc$hhold_income)

ch2$statistic
ch2$p.value 


res_df2 <- as.data.frame( as.table( ch2$stdres ))

colnames(res_df2) <- c("weather_source", "hhold_income", "std_resid")

res_df2 %>% 
  ggplot( aes(x= hhold_income, y=weather_source, fill=std_resid) )+
  geom_tile()+
  geom_text( aes( label = round(std_resid, 1)), size = 3) +
  scale_fill_gradient2(low = "#0000CD", mid = "white", high = "firebrick2", midpoint = 0) +
  labs(
    title = "Chi-squared standardized residuals",
    x = "hhold_income",
    y = "Weather source",
    fill = "Residual"
  ) +
  theme_minimal()



# chi kwadrat dla źródła i smartwoch

ch3 <- chisq.test(wc$weather_source, wc$ck_weather_watch)

res_df <- as.data.frame(
  as.table(
    ch3$stdres)) 

colnames(res_df) <- c("weather_source", "ck_weather_watch", "std_resid")

res_df %>% 
  ggplot( aes(x = ck_weather_watch, y = weather_source, fill = std_resid)) +
  geom_tile() +
  geom_text( aes( label = round(std_resid, 1)), size = 3) +
  scale_fill_gradient2(low = "#0000CD", mid = "white", high = "firebrick2", midpoint = 0) +
  labs(
    title = "Chi-squared standardized residuals",
    x = "Smartwatch likelihood",
    y = "Weather source",
    fill = "Residual"
  ) +
  theme_minimal()




##

wc %>%
  filter( !is.na( ck_weather_watch)) %>%
  filter( !is.na(age)) %>% 
  ggplot( aes(x= age, fill = ck_weather_watch))+
  geom_bar( position = "dodge", color= "white")+
  labs( x= "Age",
        y= "Number of people",
        title = "If you had a smartwatch, how likely would you be to check the weather on that device?",
        fill= "How likely?")+
  theme(plot.title = element_text( hjust = 0.2, size = 13))


wc %>% 
  filter(ck_weather == 'yes') %>%
  filter(!is.na(region)) %>% 
  count( region) %>% 
  ggplot( aes(y = reorder(region, n), x=n, fill= n,)) + 
  geom_col( 
    color= "white")+
  geom_text( aes( label = n),
             hjust = -0.3, 
             size = 3.5)+
  scale_fill_gradient(high ="#3CB371",low="lightgoldenrod1")+
  labs(x="Number of people",
       y= "Region",
       title="People who typically check a daily weather report by region")+
  theme(plot.title = element_text( hjust = -0.5, size = 13))




##### ???????????
wc %>%
  filter( !is.na( weather_source)) %>%
  filter( !is.na(region)) %>% 
  count(region, weather_source) %>%
  ggplot(aes(x = weather_source, y = region, fill = n)) +
  geom_tile() +
  scale_fill_viridis_c() +
  theme_minimal()

wc %>%
  count(ck_weather_watch) %>%
  ggplot(aes(x = reorder(ck_weather_watch, n), y = n)) +
  geom_segment(aes(xend = ck_weather_watch, yend = 0), color = "grey") +
  geom_point(size = 4, color = "blue") +
  coord_flip() +
  labs(x = "", y = "Count")
wc %>%
  count(ck_weather) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ggplot(aes(x = ck_weather, y = percent)) +
  geom_col() +
  geom_text(aes(label = paste0(round(percent,1), "%")), vjust = -0.5)




chii <- chisq.test(wc$ck_weather, wc$region)

res_dfii <- as.data.frame(
  as.table(
    chii$stdres)) 

colnames(res_dfii) <- c("ck_weather", "region", "std_resid")

res_dfii %>% 
  ggplot( aes(x = ck_weather, y = region, fill = std_resid)) +
  geom_tile() +
  geom_text( aes( label = round(std_resid, 1)), size = 3) +
  scale_fill_gradient2(low = "#0000CD", mid = "white", high = "firebrick2", midpoint = 0) +
  labs(
    title = "Chi-squared standardized residuals",
    fill = "Residual"
  ) +
  theme_minimal()


chichi <- chisq.test(wc$ck_weather, wc$weather_source)

res <- as.data.frame(as.table(chichi$stdres))

res %>% 
  ggplot(aes(x= wc.ck_weather, y= wc.weather_source, fill = Freq))+
  geom_tile()



