-- Lab 2024-03-30

-- Drop column picture from staff.
USE sakila;

ALTER TABLE staff DROP column picture;

SELECT* FROM sakila.staff;

-- A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

INSERT INTO sakila.staff (staff_id, first_name, last_name, adress_id, email, store_id, `active`, username, password, last_update)
VALUES (
	3,
    'Tammy',
    'Sanders',
    (SELECT adress_id FROM sakila.customer WHERE first_name='TAMMY' AND last_name='SANDERS'),
	(SELECT email FROM sakila.customer WHERE first_name = 'TAMMY' AND last_name = 'SANDERS'),
    (SELECT store_id FROM sakila.customer WHERE first_name = 'TAMMY' AND last_name = 'SANDERS'),
    (SELECT active FROM sakila.customer WHERE first_name = 'TAMMY' AND last_name = 'SANDERS'),
    'Tammy',
    'cdhieoi',
    CURDATE()
);

SELECT * FROM sakila.staff;

-- Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1.
-- You can use current date for the rental_date column in the rental table. 
-- Hint: Check the columns in the table rental and see what information you would need to add there.
-- You can query those pieces of information. For eg., you would notice that you need customer_id information as well. 
-- To get that you can use the following query:

-- select customer_id from sakila.customer
-- where first_name = 'CHARLOTTE' and last_name = 'HUNTER';

-- Use similar method to get inventory_id, film_id, and staff_id.

    
SELECT
	*
FROM
	sakila.inventory i
INNER JOIN
	sakila.film f
ON f.film_id = i.film_id
INNER JOIN
	sakila.customer c
ON
	c.store_id=i.store_id
WHERE
	c.first_name = "CHARLOTTE" AND title = "ACADEMY DINOSAUR";

	

	

    
SELECT * FROM rental;

select * from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';

SELECT * FROM sakila.rental;
INSERT INTO sakila.rental (
    rental_date,
	inventory_id,
	customer_id,
	return_date,
	last_update,
    staff_id
)
VALUES (
    CURDATE(),
    (SELECT inventory_id FROM sakila.inventory WHERE film_id IN (SELECT film_id FROM sakila.film WHERE title="Academy Dinosaur") AND store_id IN (SELECT store_id FROM sakila.customer WHERE first_name = 'CHARLOTTE' and last_name = 'HUNTER')LIMIT 1),
    (select customer_id from sakila.customer where first_name = 'CHARLOTTE' and last_name = 'HUNTER'),
    null,
	CURDATE(),
    (SELECT staff_id FROM sakila.staff WHERE store_id IN (SELECT store_id FROM sakila.customer WHERE first_name = 'CHARLOTTE' and last_name = 'HUNTER')LIMIT 1)
);

-- Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:

-- Check if there are any non-active users
-- Create a table backup table as suggested
-- Insert the non active users in the table backup table
-- Delete the non active users from the table customer

SELECT
customer_id, active
FROM
sakila.customer
WHERE
active=0;

CREATE TABLE
	deleted_users (
		customer_id INT,
        email VARCHAR(255),
        delete_date DATE
);

INSERT INTO deleted_users (customer_id, email, delete_date)
SELECT customer_id, email, CURDATE() FROM customer WHERE active = 0;

DELETE FROM customer WHERE active = 0;

DELETE FROM table_name WHERE customer_id IN (SELECT customer_id FROM customer WHERE active = 0);
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM customer WHERE active = 0;
