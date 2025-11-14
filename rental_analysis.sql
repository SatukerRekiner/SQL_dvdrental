DROP VIEW IF EXISTS film_rentals;

-- główny widok analityczny: cechy filmu + liczba wypożyczeń
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

--najlepsze tytuły
SELECT *
FROM film_rentals
ORDER BY rentals DESC
LIMIT 10;

--kategoria
SELECT
    category,
    SUM(rentals) AS total_rentals,
    AVG(rentals) AS avg_rentals_per_film,
    COUNT(*)     AS films_in_category
FROM film_rentals
GROUP BY category
ORDER BY total_rentals DESC;

-- wpływ ceny wypożyczenia na liczbę wypożyczeń
SELECT
    rental_rate,
    AVG(rentals) AS avg_rentals_per_film,
    MIN(rentals) AS min_rentals,
    MAX(rentals) AS max_rentals,
    COUNT(*)     AS films_count
FROM film_rentals
GROUP BY rental_rate
ORDER BY rental_rate;

-- długosc filmu vs wypożyczenia
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

-- grupa wiekowa vs popularność
SELECT
    rating,
    AVG(rentals) AS avg_rentals_per_film,
    COUNT(*)     AS films_count
FROM film_rentals
GROUP BY rating
ORDER BY avg_rentals_per_film DESC;


