# Analiza wypożyczeń filmów w PostgreSQL

Ten projekt to podstwowa analiza danych w sql z postgresql, z wykorzystaniem przykładowej bazy **dvdrental**.

Celem jest sprawdzenie, **co wpływa na to, jak często film jest wypożyczany**:
- kategoria filmu (komedia, dramat itd.),
- cena wypożyczenia (`rental_rate`),
- długość filmu (`length`),
- rating (`G`, `PG`, `R`…).

---

## Struktura projektu

```
.
├─ rental_analysis.sql           #skrypt sql
├─ dvdrental.tar                 #dane
├─ images/
│  ├─ cena_vs_wypozyczenia.png
│  ├─ dlugosc_vs_wypozyczenia.png
│  ├─ kategoria.png
│  ├─ wiek_vs_wypozczenia.png
│  └─ najlepsze_tytuły.png
└─ README.md
```
---



### A. Popularność kategorii

![Wypożyczenia wg kategorii](images/kategoria.png)

---

### B. Cena a częstotliwość wypożyczeń


![Cena vs liczba wypożyczeń](images/cena_vs_wypozyczenia.png)

To zapytanie pokazuje, jak dla każdej stawki za wypożyczenie rozkłada się średnia liczba wypożyczeń.

---

### C. Długość filmu a wypożyczenia


![Długość filmu vs wypożyczenia](images/dlugosc_vs_wypozyczenia.png)

Wynik pokazuje, czy częściej wypożyczane są filmy krótkie, średnie, długie czy bardzo długie.

---

### D. Rating (grupa wiekowa) a wypożyczenia


![Rating vs wypożyczenia](images/wiek_vs_wypozyczenia.png)

To pozwala zobaczyć, które ratingi (np. filmy rodzinne vs dla dorosłych) są średnio wypożyczane częściej.

---

### E. Najchętniej wypożyczane filmy (top10)

![Najchętniej wypożyczane filmy](images/najlepsze_tytuły.png)

## Najważniejsze wnioski (do uzupełnienia)

W tej sekcji możesz krótko opisać swoje własne obserwacje na podstawie wyników.  
Zastąp poniższe przykłady realnymi wnioskami z twoich tabel/screenów.

- **Kategorie:**  
  - Np. kategoria `[...]` generuje najwyższą łączną liczbę wypożyczeń.  
  - Niektóre kategorie mają mało filmów, ale za to bardzo wysoką średnią wypożyczeń na film.

- **Cena (`rental_rate`):**  
  - Np. filmy w cenie `X`–`Y` są wypożyczane najczęściej.  
  - Wyższa cena nie zawsze oznacza mniejszą liczbę wypożyczeń / albo odwrotnie – w zależności od wyników.

- **Długość filmu:**  
  - Np. najczęściej wypożyczane są filmy o średniej długości (60–100 minut).  
  - Filmy bardzo krótkie / bardzo długie mają mniejszą średnią liczby wypożyczeń.

- **Rating:**  
  - Np. filmy o ratingu `PG` mają najwyższą średnią liczbę wypożyczeń, co może sugerować, że tytuły „rodzinne” są popularniejsze.

---


## Licencja

Projekt ma charakter edukacyjny.  
Przykładowa baza danych **dvdrental** jest publicznie dostępna jako oficjalny przykład dla PostgreSQL.
