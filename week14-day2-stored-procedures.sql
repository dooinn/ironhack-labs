USE sakila;

DELIMITER //
CREATE PROCEDURE GetCustomersByCategory(IN categoryName VARCHAR(255))
BEGIN
  SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = categoryName
  GROUP BY first_name, last_name, email;
END;
//
DELIMITER ;

CALL GetCustomersByCategory('Action');
CALL GetCustomersByCategory('Animation');
CALL GetCustomersByCategory('Children');
CALL GetCustomersByCategory('Classics');




DELIMITER //
CREATE PROCEDURE GetCategoriesWithMoviesGreaterThan(IN min_number_of_movies INT)
BEGIN
  SELECT c.name AS category_name, COUNT(f.film_id) AS number_of_movies
  FROM category c
  LEFT JOIN film_category fc ON c.category_id = fc.category_id
  LEFT JOIN film f ON fc.film_id = f.film_id
  GROUP BY c.name
  HAVING number_of_movies > min_number_of_movies;
END;
//
DELIMITER ;

CALL GetCategoriesWithMoviesGreaterThan(60);







