# WeatherCheck Analyst

Projekt skupia się na analizie zbioru danych **`weather_check`** z serwisu **FiveThirtyEight**. 

Głównym celem badania jest zrozumienie, jak grupy demograficzne (wiek, płeć, dochód, region zamieszkania) różnią się w zachowaniach i nawykach związanych ze sprawdzaniem prognozy pogody oraz stosunkiem do nowych technologii (smartwatchy).


## Raport z Analizy

Pełny, wyrenderowany raport analityczny wraz ze wszystkimi wykresami, mapami i tabelami jest dostępny bezpośrednio w repozytorium:

**[Zobacz pełną analizę (`weathercheck-analyst.md`)](https://github.com/patrycja2005/weathercheck-R-project/blob/main/weathercheck-analyst.md)**


## Wykorzystane Zmienne

| Nazwa zmiennej | Opis |
| :--- | :--- |
| `respondent_id` | Identyfikator respondenta |
| `ck_weather` | Czy zazwyczaj sprawdzasz codzienną prognozę pogody? (`yes`/`no`) |
| `weather_source` | Główne źródło informacji pogodowych |
| `weather_source_site` | Konkretna strona lub aplikacja podana przez respondenta |
| `ck_weather_watch` | Gotowość do sprawdzania pogody na smartwatchu |
| `age` | Przedział wiekowy respondenta |
| `female` / `sex` | Płeć respondenta (`Male`, `Female`, `not given`) |
| `hhold_income` | Łączny roczny dochód gospodarstwa domowego |
| `region` | Region geograficzny USA |


## Główne Wnioski z Analizy

* **Profil typowego odbiorcy:** Najbardziej regularnie pogodę sprawdzają **kobiety powyżej 45. roku życia**, zamieszkujące regiony USA o dużej zmienności klimatycznej (**Pacific**, **East North Central**, **South Atlantic**).
* **Luka pokoleniowa w źródłach informacji pogodowej:** 
  * Osoby młodsze (18–44 lat) korzystają głównie z **domyślnych aplikacji mobilnych** w telefonie.
  * Osoby starsze (60+) czerpią informacje niemal wyłącznie z **lokalnych wiadomości telewizyjnych (Local TV News)**.
* **Adopcja Smartwatchy:** Ponad **70% respondentów** wykazuje chęć sprawdzania pogody na inteligentnych zegarkach (najwyższy entuzjazm w grupie wiekowej 45–59 lat).
* **Weryfikacja hipotezy (Test $\chi^2$):** Test Chi-kwadrat Pearsona wykazuje brak istotności statystycznej ($p\text{-value} = 0.915 > 0.05$). **Zamożność gospodarstwa domowego nie wpływa na chęć korzystania ze smartwatcha do sprawdzania pogody.**


## Narzędzia

* **Język:** R
* **Pakiety:**
  * `tidyverse` (`ggplot2`, `dplyr`) – czyszczenie, przekształcanie i wizualizacja danych
  * `fivethirtyeight` – źródło zbioru danych
  * `usmap` – kartogramy i wizualizacja danych na mapie USA
  * `knitr` – raportowanie i tabele


## Struktura repozytorium

``` text
├── .gitignore                          # Plik określający ignorowane elementy przez Git
├── weathercheck-R-project.Rproj        # Plik konfiguracyjny projektu RStudio
├── weathercheck-analyst.Rmd            # Główny kod źródłowy raportu (R Markdown)
├── weathercheck-analyst.md            # Wygenerowany raport w formacie GitHub Markdown <- GŁÓWNA ANALIZA
├── code/                               # Skrypty i kod pomocniczy w R
└── weathercheck-analyst_files/         # Wygenerowane pliki graficzne do raportu
