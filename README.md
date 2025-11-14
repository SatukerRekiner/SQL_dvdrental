# Analiza wypożyczeń filmów w PostgreSQL (baza dvdrental)

Ten projekt to podstwowa analiza danych w sql z postgresql, z wykorzystaniem przykładowej bazy **dvdrental**.

Celem jest sprawdzenie, **co wpływa na to, jak często film jest wypożyczany**:
- kategoria filmu (komedia, dramat itd.),
- cena wypożyczenia (`rental_rate`),
- długość filmu (`length`),
- rating (`G`, `PG`, `R`…).

---

## Struktura projektu


.
├─ rental_analysis.sql (skrypt sql)
├─ dvdrental.tar (dane)
├─ images/
│  ├─ cena_vs_wypozyczenia.png
│  ├─ dlugosc_vs_wypozyczenia.png
│  ├─ kategoria.png
│  ├─ wiek_vs_wypozczenia.png
│  └─ najlepsze_tytuły.png
└─ README.md

---



Główne kroki:

---

## 3.1. Eksploracja schematu

Plik `sql/01_explore_schema.sql` (przykład):

```sql
-- lista tabel w schemacie public
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- szybki podgląd kluczowych tabel
SELECT * FROM film      LIMIT 5;
SELECT * FROM category  LIMIT 5;
SELECT * FROM rental    LIMIT 5;
SELECT * FROM inventory LIMIT 5;
```

Ten etap służy tylko temu, żeby ogarnąć, jakie są tabele i co mniej więcej zawierają.

---

## 3.2. Widok analityczny `film_rentals`

Główny pomysł: zbudować jeden widok, w którym **każdy film to jeden wiersz** z:

- tytułem,
- kategorią,
- ceną wypożyczenia (`rental_rate`),
- długością (`length`),
- ratingiem,
- liczbą wypożyczeń (`rentals`).

Plik `sql/02_film_rentals_view_and_analysis.sql` zaczyna się od:

```sql
DROP VIEW IF EXISTS film_rentals;

CREATE VIEW film_rentals AS
SELECT
    f.film_id,
    f.title,
    c.name        AS category,
    f.rental_rate,
    f.length,
    f.rating,
    COUNT(r.rental_id) AS rentals
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c       ON c.category_id = fc.category_id
JOIN inventory i      ON i.film_id = f.film_id
LEFT JOIN rental r    ON r.inventory_id = i.inventory_id
GROUP BY
    f.film_id,
    f.title,
    c.name,
    f.rental_rate,
    f.length,
    f.rating;
```

Szybkie sprawdzenie:

```sql
SELECT *
FROM film_rentals
ORDER BY rentals DESC
LIMIT 10;
```

Jeżeli w wynikach widać sensowne dane (tytuł, kategoria, cena, długość, liczba wypożyczeń), widok działa i można robić dalej analizę.

---

## 3.3. Zapytania analityczne

Wszystkie poniższe zapytania korzystają z widoku `film_rentals`.

### A. Popularność kategorii

```sql
SELECT
    category,
    SUM(rentals) AS total_rentals,
    AVG(rentals) AS avg_rentals_per_film,
    COUNT(*)     AS films_in_category
FROM film_rentals
GROUP BY category
ORDER BY total_rentals DESC;
```

Screenshot (przykładowa ścieżka):

![Wypożyczenia wg kategorii](images/rentals_by_category.png)

---

### B. Cena a częstotliwość wypożyczeń

```sql
SELECT
    rental_rate,
    AVG(rentals) AS avg_rentals_per_film,
    MIN(rentals) AS min_rentals,
    MAX(rentals) AS max_rentals,
    COUNT(*)     AS films_count
FROM film_rentals
GROUP BY rental_rate
ORDER BY rental_rate;
```

Screenshot:

![Cena vs liczba wypożyczeń](images/price_vs_rentals.png)

To zapytanie pokazuje, jak dla każdej stawki za wypożyczenie rozkłada się średnia liczba wypożyczeń.

---

### C. Długość filmu a wypożyczenia

```sql
SELECT
    CASE
        WHEN length < 60 THEN 'short (<60 min)'
        WHEN length BETWEEN 60 AND 100 THEN 'medium (60–100)'
        WHEN length BETWEEN 101 AND 140 THEN 'long (101–140)'
        ELSE 'very long (>140)'
    END AS length_group,
    AVG(rentals) AS avg_rentals_per_film,
    COUNT(*)     AS films_count
FROM film_rentals
GROUP BY length_group
ORDER BY avg_rentals_per_film DESC;
```

Screenshot:

![Długość filmu vs wypożyczenia](images/length_vs_rentals.png)

Wynik pokazuje, czy częściej wypożyczane są filmy krótkie, średnie, długie czy bardzo długie.

---

### D. Rating (grupa wiekowa) a wypożyczenia

```sql
SELECT
    rating,
    AVG(rentals) AS avg_rentals_per_film,
    COUNT(*)     AS films_count
FROM film_rentals
GROUP BY rating
ORDER BY avg_rentals_per_film DESC;
```

Screenshot:

![Rating vs wypożyczenia](images/rating_vs_rentals.png)

To pozwala zobaczyć, które ratingi (np. filmy rodzinne vs dla dorosłych) są średnio wypożyczane częściej.

---

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

## Możliwe rozszerzenia

Kilka pomysłów, jak ten projekt można rozwinąć w przyszłości:

- Dodać **funkcje okienkowe** (window functions), np. ranking filmów w ramach każdej kategorii.
- Zrobić analizę w czasie – wypożyczenia wg miesiąca/roku, sezonowość.
- Wyeksportować dane do **Pythona lub R** i dorobić wykresy.
- Zbudować prosty **dashboard / API**, które korzysta z tych zapytań SQL.

---

## Licencja

Projekt ma charakter edukacyjny.  
Przykładowa baza danych **dvdrental** jest publicznie dostępna jako oficjalny przykład dla PostgreSQL.
