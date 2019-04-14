USE sakila

-- 1a:
SELECT first_name, last_name FROM actor;

-- 1b:
SELECT CONCAT(first_name, ' ', last_name) AS `Actor Name` FROM actor;

-- 2a:
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- 2b:
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%gen%';

-- 2c:
SELECT actor_id, last_name, first_name FROM actor WHERE last_name LIKE '%li%';

-- 2d:
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh' , 'China');

-- 3a:
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_name;

-- 3b:
ALTER TABLE actor
DROP COLUMN description;

-- 4a:
SELECT DISTINCT last_name AS unique_name, (SELECT COUNT(last_name) FROM actor WHERE last_name = unique_name )
FROM actor;

-- 4b:
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name HAVING COUNT(last_name) > 1;

-- 4c:
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS'

-- 4d:
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS'

-- 5a:
SHOW CREATE TABLE address

-- 6a:
SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff ON
address.address_id=staff.address_id;

-- 6b:
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) FROM staff
INNER JOIN payment WHERE staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%' GROUP BY staff.staff_id ;

-- 6c:
SELECT film.title, COUNT(film_actor.actor_id) FROM film
INNER JOIN film_actor WHERE film.film_id = film_actor.film_id GROUP BY film.film_id;

-- 6d:
SELECT film.title, COUNT(inventory.inventory_id) FROM inventory 
INNER JOIN film WHERE film.film_id = inventory.film_id AND film.title = 'Hunchback Impossible';

-- 6e:
SELECT customer.first_name, customer.last_name, SUM(payment.amount) FROM payment
INNER JOIN customer WHERE payment.customer_id = customer.customer_id GROUP BY customer.customer_id ORDER BY last_name;

-- 7a:
SELECT title
	FROM film
	WHERE language_id
	IN (
		SELECT language_id
		FROM language
		WHERE name = 'English'
		)
			AND film.title LIKE 'Q%' OR film.title LIKE 'K%';
            
-- 7b:
SELECT first_name, last_name
	FROM actor
    WHERE actor_id
    IN (
		SELECT actor_id
        FROM film_actor
        WHERE film_id
        IN (
			SELECT film_id
            FROM film
            WHERE title = 'Alone Trip')
            );

-- 7c:
SELECT customer.first_name, customer.last_name, customer.email FROM customer 
INNER JOIN address ON customer.address_id = address.address_id 
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id WHERE country.country = 'Canada';

-- 7d:
SELECT title FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id 
WHERE category.name = 'Family';

-- 7e:
SELECT film.title, COUNT(rental.rental_id) FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id GROUP BY film.title ORDER BY COUNT(rental.rental_id)DESC;

-- 7f:
SELECT store.store_id, SUM(payment.amount) FROM store 
INNER JOIN staff ON store.store_id = staff.store_id
INNER JOIN payment ON staff.staff_id = payment.staff_id GROUP BY store.store_id ;

-- 7g:
SELECT store.store_id, city.city, country.country FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON city.city_id = address.city_id
INNER JOIN country ON city.country_id = country.country_id;

-- 7h:
SELECT category.name AS 'Top 5 Genres', SUM(payment.amount) AS 'Gross Revenue' FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY category.name ORDER BY SUM(payment.amount)DESC LIMIT 5 ;

-- 8a:
CREATE VIEW top_five_genres AS SELECT category.name AS 'Top 5 Genres', SUM(payment.amount) AS 'Gross Revenue' FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY category.name ORDER BY SUM(payment.amount)DESC LIMIT 5 ;

-- 8b:
SELECT * FROM top_five_genres;

-- 8c:
DROP VIEW top_five_genres;
