-- lab-aggregation-revisited-subqueries


USE sakila;




-- Select the first name, last name, and email address of all the customers who have rented a movie.
WITH rented_customer AS (
SELECT customer_id, COUNT(*) AS count FROM rental
GROUP BY customer_id
),
customer_info AS (
SELECT customer_id, first_name, last_name, email FROM customer
)
SELECT rc.customer_id, ci.first_name, ci.last_name, ci.email FROM rented_customer rc
LEFT JOIN customer_info ci
ON rc.customer_id = ci.customer_id;


-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
WITH pay_customer AS (
SELECT  customer_id, ROUND(AVG(amount),2) AS avg_pay  from payment
GROUP BY customer_Id
),
customer_info AS (
SELECT customer_id, CONCAT(first_name," ",last_name) as name FROM customer
)
SELECT pc.customer_id, ci.name, pc.avg_pay FROM pay_customer pc
LEFT JOIN customer_info ci
ON pc.customer_id = ci.customer_id;


SELECT * FROM category;

WITH rented_customer AS (
SELECT customer_id, COUNT(*) AS count FROM rental
GROUP BY customer_id
),
customer_info AS (
SELECT customer_id, first_name, last_name, email FROM customer
)
SELECT rc.customer_id, ci.first_name, ci.last_name, ci.email FROM rented_customer rc
LEFT JOIN customer_info ci
ON rc.customer_id = ci.customer_id;




-- Select the name and email address of all the customers who have rented the "Action" movies.





-- Method1. Multiple Joins


SELECT CONCAT(ct.first_name, ' ', ct.last_name) AS name, ct.email
FROM (
  SELECT DISTINCT r.customer_id
  FROM rental r
  LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
  LEFT JOIN film_category fc ON i.film_id = fc.film_id
  LEFT JOIN category c ON c.category_id = fc.category_id
  WHERE c.name = 'Action'
) AS distinct_customers
LEFT JOIN customer ct ON distinct_customers.customer_id = ct.customer_id;




-- Method2. Subquery, IN
SELECT CONCAT(ct.first_name, ' ', ct.last_name) AS name, ct.email
FROM customer ct
WHERE ct.customer_id IN (
	SELECT r.customer_id 
	FROM rental r
	WHERE r.inventory_id IN (
		SELECT i.inventory_id 
		FROM inventory i
		WHERE i.film_id IN (
			SELECT fc.film_id 
			FROM film_category fc
			WHERE fc.category_id IN (
				SELECT c.category_id 
				FROM category c
				WHERE c.name = 'Action'
			)
		)
	)
);

-- Results are exactly same








-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

SELECT *,
       CASE
           WHEN amount BETWEEN 0 AND 2 THEN 'low'
           WHEN amount > 2 AND amount <= 4 THEN 'medium'
           WHEN amount > 4 THEN 'high'
           ELSE 'undefined'
       END AS transaction_class
FROM payment;







