weathercheck-analyst
================
Patrycja Kornobis
2026-08-13

# Wstęp

Projekt analizuje zbiór danych *weather_check* z pakietu
**fivethirtyeight** (dostępny również na
[GitHubie](https://github.com/fivethirtyeight/data/tree/master/weather-check)).

Badanie sprawdza, jak grupy demograficzne (wiek, płeć, dochód, region)
różnią się w zachowaniach związanych z pogodą — m.in. w częstotliwości
sprawdzania prognoz, wyborze źródeł informacji czy korzystaniu ze
smartwatchy.

## Przegląd zmiennych

Zbiór danych zawiera 928 obserwacji (respondentów) oraz 10 zmiennych:

| Nazwa zmiennej | Opis |
|----|----|
| `respondent_id` | Identyfikator respondenta |
| `ck_weather` | Czy zazwyczaj sprawdzasz codzienną prognozę pogody? (Zmienna logiczna przekształcona w faktor: “yes”/“no”) |
| `weather_source` | W jaki sposób zazwyczaj sprawdzasz pogodę? |
| `weather_source_site` | Konkretna strona internetowa lub aplikacja wpisana przez osoby, które wybrały odpowiedź “A specific website or app” |
| `ck_weather_watch` | Gdybyś posiadał(a) smartwatcha, jak prawdopodobne jest, że sprawdzał(a)byś na nim pogodę? |
| `age` | Wiek |
| `female` | Płeć (wartość logiczna TRUE/FALSE) |
| `hhold_income` | Łączny dochód gospodarstwa domowego z ubiegłego roku |
| `region` | Region USA |
| `sex` | Dodatkowa zmienna utworzona na podstawie zmiennej *female* (“Male”, “Female”, “not given”) |

# Analiza

W tej części przejdziemy do szczegółowej analizy zachowań respondentów.
Zbadamy m.in., jak często sprawdzają oni prognozę pogody, jakich źródeł
informacji używają oraz jakie mają podejście do nowych technologii
(smartwatchy).

Szczególną uwagę poświęcimy różnicom demograficznym — sprawdzimy, czy
płeć, wiek lub miejsce zamieszkania mają istotny wpływ na nawyki
związane ze sprawdzaniem pogody.

<img src="weathercheck-analyst_files/figure-gfm/unnamed-chunk-2-1.png" style="display: block; margin: auto;" />
