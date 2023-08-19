USE sakila;

SELECT s.store_id, COUNT(r.rental_id) as total_business, SUM(f.rental_rate) FROM rental r
LEFT JOIN store s
ON r.staff_id = s.manager_staff_id
LEFT JOIN inventory i
ON i.inventory_id = r.inventory_id
LEFT JOIN film f
ON f.film_id = i.film_id
GROUP BY s.store_id;






DELIMITER //
CREATE PROCEDURE GetTotalBusiness()
BEGIN
  SELECT s.store_id, COUNT(r.rental_id) as total_business, SUM(f.rental_rate)
  FROM rental r
  LEFT JOIN store s
  ON r.staff_id = s.manager_staff_id
  LEFT JOIN inventory i
  ON i.inventory_id = r.inventory_id
  LEFT JOIN film f
  ON f.film_id = i.film_id
  GROUP BY s.store_id;
END;
//
DELIMITER ;


CALL GetTotalBusiness();

DELIMITER //
CREATE PROCEDURE GetTotalBusinessForStore(IN store_id INT)
BEGIN
  SELECT s.store_id, COUNT(r.rental_id) as total_business, SUM(f.rental_rate) as total_sales
  FROM rental r
  LEFT JOIN store s
  ON r.staff_id = s.manager_staff_id
  LEFT JOIN inventory i
  ON i.inventory_id = r.inventory_id
  LEFT JOIN film f
  ON f.film_id = i.film_id
  WHERE s.store_id = store_id
  GROUP BY s.store_id;
END;
//
DELIMITER ;

CALL GetTotalBusinessForStore(1);


DELIMITER //
CREATE PROCEDURE GetTotalBusinessForStore_1(IN store_id INT, OUT total_sales_value FLOAT)
BEGIN
  SELECT SUM(f.rental_rate) INTO total_sales_value
  FROM rental r
  LEFT JOIN store s
  ON r.staff_id = s.manager_staff_id
  LEFT JOIN inventory i
  ON i.inventory_id = r.inventory_id
  LEFT JOIN film f
  ON f.film_id = i.film_id
  WHERE s.store_id = store_id;
END;
//
DELIMITER ;


SET @total_sales_value = 0;


CALL GetTotalBusinessForStore_1(1, @total_sales_value);

SELECT @total_sales_value AS total_sales_for_store;





DELIMITER //
CREATE PROCEDURE GetTotalBusinessForStore_2(IN store_id INT, OUT total_sales_value FLOAT, OUT flag VARCHAR(10))
BEGIN
  SELECT SUM(f.rental_rate) INTO total_sales_value
  FROM rental r
  LEFT JOIN store s
  ON r.staff_id = s.manager_staff_id
  LEFT JOIN inventory i
  ON i.inventory_id = r.inventory_id
  LEFT JOIN film f
  ON f.film_id = i.film_id
  WHERE s.store_id = store_id;

  IF total_sales_value > 30000 THEN
    SET flag = 'green_flag';
  ELSE
    SET flag = 'red_flag';
  END IF;
END;
//
DELIMITER ;

SET @total_sales_value = 0;
SET @flag = '';

CALL GetTotalBusinessForStore_2(1, @total_sales_value, @flag);

-- Print the results
SELECT @total_sales_value AS total_sales_for_store, @flag AS status_flag;
















