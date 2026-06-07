-- =======================
-- MODULE 2: DVD RENTAL BUSINESS ANALYSIS
-- =======================

-- REVENUE ANALYTICS

-- Total Company Revenue
SELECT
    ROUND(SUM(amount),2) AS total_revenue
FROM payment;

-- Revenue by Month
SELECT
    DATE_TRUNC('month', payment_date) AS month,
    ROUND(SUM(amount),2) AS revenue
FROM payment
GROUP BY month
ORDER BY month;

-- Revenue by Store
SELECT
    s.store_id,
    ROUND(SUM(p.amount),2) AS revenue
FROM payment p
JOIN staff s
ON p.staff_id = s.staff_id
GROUP BY s.store_id;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMER ANALYTICS

-- TOP 20 Customers spending
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS lifetime_value
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY lifetime_value DESC
LIMIT 20;

-- AVERAGE Customer Spend
SELECT
    ROUND(AVG(customer_total),2)
FROM
(
    SELECT
        customer_id,
        SUM(amount) AS customer_total
    FROM payment
    GROUP BY customer_id
) x;

-- Customer Spending Rank
SELECT
    customer_id,
    SUM(amount) AS total_spent,
    RANK() OVER (
        ORDER BY SUM(amount) DESC
    ) AS spending_rank
FROM payment
GROUP BY customer_id;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FILM PERFORMANCE

-- Most Rented Movies
SELECT
    f.title,
    COUNT(*) AS rentals
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rentals DESC
LIMIT 20;

-- Highest Revenue Films
SELECT
    f.title,
    SUM(p.amount) AS revenue
FROM payment p
JOIN rental r
ON p.rental_id = r.rental_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY revenue DESC
LIMIT 20;

-- Film Revenue by Category
SELECT
    c.name,
    SUM(p.amount) AS revenue
FROM payment p
JOIN rental r
ON p.rental_id = r.rental_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY revenue DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






