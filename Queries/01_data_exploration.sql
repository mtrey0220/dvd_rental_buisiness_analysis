1) ROW COUNTS:
-- ============================================================
-- MODULE 1: DATA EXPLORATION & SCHEMA MAPPING
-- Project: DVD Rental Business Intelligence
-- Author:  Trey Mitchell | B.S. Mathematics, Minor CS
-- DB:      dvdrental (PostgreSQL)
-- ============================================================
 
 
-- ============================================================
-- SECTION 1: ROW COUNTS 
-- ============================================================
-- Business question: What is the scale of this dataset?
 
SELECT 'actor'         AS table_name, COUNT(*) AS row_count FROM actor
UNION ALL
SELECT 'address',      COUNT(*) FROM address
UNION ALL
SELECT 'category',     COUNT(*) FROM category
UNION ALL
SELECT 'city',         COUNT(*) FROM city
UNION ALL
SELECT 'country',      COUNT(*) FROM country
UNION ALL
SELECT 'customer',     COUNT(*) FROM customer
UNION ALL
SELECT 'film',         COUNT(*) FROM film
UNION ALL
SELECT 'film_actor',   COUNT(*) FROM film_actor
UNION ALL
SELECT 'film_category',COUNT(*) FROM film_category
UNION ALL
SELECT 'inventory',    COUNT(*) FROM inventory
UNION ALL
SELECT 'language',     COUNT(*) FROM language
UNION ALL
SELECT 'payment',      COUNT(*) FROM payment
UNION ALL
SELECT 'rental',       COUNT(*) FROM rental
UNION ALL
SELECT 'staff',        COUNT(*) FROM staff
UNION ALL
SELECT 'store',        COUNT(*) FROM store
ORDER BY row_count DESC;

2) NULL AUDIT
-- ============================================================
-- SECTION 2: NULL AUDIT 
-- ============================================================
-- Business question: Are there gaps that could skew analysis?
 
-- Customer table null audit
SELECT
    COUNT(*)                                        AS total_rows,
    COUNT(*) FILTER (WHERE customer_id  IS NULL)   AS null_customer_id,
	COUNT(*) FILTER (WHERE store_id  IS NULL)   AS null_store_id,
    COUNT(*) FILTER (WHERE first_name   IS NULL)   AS null_first_name,
    COUNT(*) FILTER (WHERE last_name    IS NULL)   AS null_last_name,
    COUNT(*) FILTER (WHERE email        IS NULL)   AS null_email,
    COUNT(*) FILTER (WHERE address_id   IS NULL)   AS null_address_id,
    COUNT(*) FILTER (WHERE activebool       IS NULL)   AS null_activebool,
    COUNT(*) FILTER (WHERE create_date  IS NULL)   AS null_create_date,
	COUNT(*) FILTER (WHERE last_update  IS NULL)   AS null_last_update,
	COUNT(*) FILTER (WHERE active  IS NULL)   AS null_active
FROM customer;
 
-- Payment table null audit 
SELECT
    COUNT(*)                                         AS total_rows,
    COUNT(*) FILTER (WHERE payment_id   IS NULL)    AS null_payment_id,
    COUNT(*) FILTER (WHERE customer_id  IS NULL)    AS null_customer_id,
    COUNT(*) FILTER (WHERE staff_id     IS NULL)    AS null_staff_id,
    COUNT(*) FILTER (WHERE rental_id    IS NULL)    AS null_rental_id,
    COUNT(*) FILTER (WHERE amount       IS NULL)    AS null_amount,
    COUNT(*) FILTER (WHERE payment_date IS NULL)    AS null_payment_date
FROM payment;
 
-- Rental table null audit 
SELECT
    COUNT(*)                                         AS total_rows,
    COUNT(*) FILTER (WHERE rental_id    IS NULL)    AS null_rental_id,
    COUNT(*) FILTER (WHERE rental_date  IS NULL)    AS null_rental_date,
    COUNT(*) FILTER (WHERE inventory_id IS NULL)    AS null_inventory_id,
    COUNT(*) FILTER (WHERE customer_id  IS NULL)    AS null_customer_id,
    COUNT(*) FILTER (WHERE return_date  IS NULL)    AS null_return_date,  -- expected NULLs
    COUNT(*) FILTER (WHERE staff_id     IS NULL)    AS null_staff_id,
	COUNT(*) FILTER (WHERE last_update  IS NULL)   AS null_last_update
FROM rental;
 
-- Film table null audit
SELECT
    COUNT(*)                                              AS total_rows,
	COUNT(*) FILTER (WHERE film_id          IS NULL)     AS null_film_id,
    COUNT(*) FILTER (WHERE title            IS NULL)     AS null_title,
    COUNT(*) FILTER (WHERE description      IS NULL)     AS null_description,
    COUNT(*) FILTER (WHERE release_year     IS NULL)     AS null_release_year,
    COUNT(*) FILTER (WHERE language_id      IS NULL)     AS null_language_id,
    COUNT(*) FILTER (WHERE rental_duration  IS NULL)     AS null_rental_duration,
    COUNT(*) FILTER (WHERE rental_rate      IS NULL)     AS null_rental_rate,
	COUNT(*) FILTER (WHERE length          IS NULL)     AS null_length,
	COUNT(*) FILTER (WHERE replacement_cost          IS NULL)     AS null_replacement_cost,
    COUNT(*) FILTER (WHERE rating           IS NULL)     AS null_rating,
	COUNT(*) FILTER (WHERE last_update          IS NULL)     AS null_last_update,
	COUNT(*) FILTER (WHERE special_features          IS NULL)     AS null_special_features,
	COUNT(*) FILTER (WHERE fulltext          IS NULL)     AS null_fulltext
FROM film;

3) DATE RANGES
-- ============================================================
-- SECTION 3: DATE RANGES 
-- ============================================================
-- Business question: Are we looking at months or years of data?
 
SELECT
    MIN(payment_date) AS first_payment,
    MAX(payment_date) AS last_payment,
    MAX(payment_date) - MIN(payment_date) AS date_span,
    COUNT(DISTINCT DATE_TRUNC('month', payment_date)) AS months_of_data,
    EXTRACT(YEAR FROM MIN(payment_date)) AS start_year,
    EXTRACT(YEAR FROM MAX(payment_date)) AS end_year
FROM payment;
 
SELECT
    MIN(rental_date)  AS first_rental,
    MAX(rental_date)  AS last_rental,
    MAX(rental_date) - MIN(rental_date) AS rental_span
FROM rental;
 
SELECT
    MIN(create_date)  AS earliest_customer,
    MAX(create_date)  AS latest_customer
FROM customer;
 
4) UNIQUE VALUES
-- ============================================================
-- SECTION 4: DISTINCT VALUE COUNTS
-- ============================================================
-- Business question: How many unique customers, films, stores exist?
 
SELECT
    (SELECT COUNT(DISTINCT customer_id) FROM customer)  AS unique_customers,
    (SELECT COUNT(DISTINCT film_id)     FROM film)      AS unique_films,
    (SELECT COUNT(DISTINCT store_id)    FROM store)     AS unique_stores,
    (SELECT COUNT(DISTINCT staff_id)    FROM staff)     AS unique_staff,
    (SELECT COUNT(DISTINCT name)        FROM category)  AS film_categories,
    (SELECT COUNT(DISTINCT name)        FROM language)  AS languages,
    (SELECT COUNT(DISTINCT city_id)     FROM city)      AS unique_cities,
    (SELECT COUNT(DISTINCT country_id)  FROM country)   AS unique_countries;

5) FILM PROFILE
-- ============================================================
-- SECTION 5: FILM PROFILE 
-- ============================================================
-- Business question: What does our film catalog look like?
 
-- Films by rating
SELECT rating, COUNT(*) AS film_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_catalog
FROM film
GROUP BY rating
ORDER BY film_count DESC;
 
-- Films by category
SELECT c.name AS category, COUNT(f.film_id) AS film_count,
    ROUND(COUNT(f.film_id) * 100.0 / SUM(COUNT(f.film_id)) OVER (), 1) AS pct_of_catalog
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY film_count DESC;
 
-- Rental rate distribution
SELECT rental_rate, COUNT(*) AS film_count
FROM film
GROUP BY rental_rate
ORDER BY rental_rate;
 
-- Rental duration distribution (days)
SELECT rental_duration, COUNT(*) AS film_count
FROM film
GROUP BY rental_duration
ORDER BY rental_duration;
 
-- Film length (runtime) summary stats
SELECT
    MIN(length) AS min_runtime_min,
    MAX(length) AS max_runtime_min,
    ROUND(AVG(length), 1) AS avg_runtime_min,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY length) AS median_runtime_min
FROM film;
 
 6) CUSTOMER PROFILE
-- ============================================================
-- SECTION 6: CUSTOMER PROFILE 
-- ============================================================
-- Business question: Who are our customers and where do they come from?
 
-- Active vs inactive customers
SELECT
    CASE WHEN active = 1 THEN 'Active' ELSE 'Inactive' END AS status,
    COUNT(*) AS customer_count
FROM customer
GROUP BY active;
 
-- Customer distribution by country (top 15)
SELECT co.country, COUNT(cu.customer_id) AS customer_count
FROM customer cu
JOIN address a  ON cu.address_id  = a.address_id
JOIN city ci    ON a.city_id      = ci.city_id
JOIN country co ON ci.country_id  = co.country_id
GROUP BY co.country
ORDER BY customer_count DESC
LIMIT 15;
 
-- Customer distribution by city (top 15)
SELECT ci.city, co.country, COUNT(cu.customer_id) AS customer_count
FROM customer cu
JOIN address a  ON cu.address_id  = a.address_id
JOIN city ci    ON a.city_id      = ci.city_id
JOIN country co ON ci.country_id  = co.country_id
GROUP BY ci.city, co.country
ORDER BY customer_count DESC
LIMIT 15;
 
-- New customers per month (growth trend)
SELECT
    DATE_TRUNC('month', create_date) AS month,
    COUNT(*) AS new_customers
FROM customer
GROUP BY month
ORDER BY month;

7) REVENUE ANALYSIS
-- ============================================================
-- SECTION 7: RENTAL BEHAVIOR 
-- ============================================================
-- Business question: How active are rentals — volume, timing, duration?
 
-- Rentals by day of week (0=Sunday in PostgreSQL)
SELECT
    TO_CHAR(rental_date, 'Day') AS day_of_week,
    EXTRACT(DOW FROM rental_date) AS day_num,
    COUNT(*) AS rental_count
FROM rental
GROUP BY day_of_week, day_num
ORDER BY day_num;
 
-- Rentals by hour of day
SELECT
    EXTRACT(HOUR FROM rental_date) AS hour_of_day,
    COUNT(*) AS rental_count
FROM rental
GROUP BY hour_of_day
ORDER BY hour_of_day;
 
-- Rentals by month
SELECT
    DATE_TRUNC('month', rental_date) AS month,
    COUNT(*) AS rental_count
FROM rental
GROUP BY month
ORDER BY month;
 
-- Average rental duration (actual vs allowed)
SELECT
    ROUND(AVG(EXTRACT(EPOCH FROM (return_date - rental_date)) / 86400
    )::NUMERIC, 2) AS avg_actual_days,
    ROUND(AVG(f.rental_duration), 2) AS avg_allowed_days
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id      = f.film_id
WHERE r.return_date IS NOT NULL;
 
8) PAYMENT PROFILE
-- ============================================================
-- SECTION 8: PAYMENT PROFILE
-- ============================================================
-- Business question: What does payment volume and amount look like?
 
SELECT
    COUNT(*) AS total_payments,
    SUM(amount) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_payment,
    MIN(amount) AS min_payment,
    MAX(amount) AS max_payment,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount) AS median_payment
FROM payment;
 
-- Payment amount buckets
SELECT
    CASE
        WHEN amount < 1.00  THEN 'Under $1'
        WHEN amount < 2.00  THEN '$1.00 – $1.99'
        WHEN amount < 3.00  THEN '$2.00 – $2.99'
        WHEN amount < 4.00  THEN '$3.00 – $3.99'
        WHEN amount < 5.00  THEN '$4.00 – $4.99'
        ELSE '$5.00+'
    END AS bucket,
    COUNT(*) AS payment_count,
    ROUND(SUM(amount), 2) AS bucket_revenue
FROM payment
GROUP BY bucket
ORDER BY MIN(amount);
 
-- Revenue by store (via staff → store)
SELECT s.store_id, COUNT(p.payment_id) AS payment_count,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    ROUND(AVG(p.amount), 2)     AS avg_payment
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.store_id
ORDER BY total_revenue DESC;

9) ACTOR PROFILE
-- ============================================================
-- SECTION 10: ACTOR PROFILE 
-- ============================================================
-- Business question: Who are the most prolific actors in our catalog?
 
-- Top 15 most-featured actors
SELECT
    a.first_name || ' ' || a.last_name  AS actor_name,
    COUNT(fa.film_id) AS films_in_catalog
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY actor_name
ORDER BY films_in_catalog DESC
LIMIT 15;
 
-- Average actors per film
SELECT
    ROUND(AVG(actor_count), 1) AS avg_actors_per_film
FROM (
    SELECT film_id, COUNT(actor_id) AS actor_count
    FROM film_actor
    GROUP BY film_id
) sub;
 
-- Films with the largest casts
SELECT
    f.title,
    COUNT(fa.actor_id) AS cast_size
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY cast_size DESC
LIMIT 10;
 
10) DATA QUALITY FLAGS
-- ============================================================
-- SECTION 11: DATA QUALITY FLAGS 
-- ============================================================
-- Business question: Are there records that look wrong?
 
-- Payments with $0 amount (free rentals? data error?)
SELECT *
FROM payment
WHERE amount = 0;
 
-- Rentals returned BEFORE they were rented (impossible dates) (RETURNS NOTHING)
SELECT
    rental_id,
    rental_date,
    return_date,
    return_date - rental_date AS duration
FROM rental
WHERE return_date < rental_date;
 
-- Customers with duplicate email addresses (RETURNS NOTHING)
SELECT
    email,
    COUNT(*) AS occurrences
FROM customer
GROUP BY email
HAVING COUNT(*) > 1;
 
-- Films with no category assigned (returns nothing)
SELECT f.film_id, f.title
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id IS NULL;
 
-- Staff with no store assigned (returns nothing)
SELECT staff_id, first_name, last_name
FROM staff
WHERE store_id IS NULL;
 
-- Rentals with no corresponding payment (lost revenue?)
SELECT
    r.rental_id,
    r.customer_id,
    r.rental_date
FROM rental r
LEFT JOIN payment p ON r.rental_id = p.rental_id
WHERE p.payment_id IS NULL
LIMIT 20;













