-- Part 1a:the first and last names of all actors in the actors table
USE sakila;
SELECT first_name, last_name FROM actor;

-- Part 1b:display the names in one column in upper case
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

-- Part 2a:create a query to find the id number, first name, and last name of some Joe
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = 'Joe';

-- Part 2b: create a query to find all actors whose last names have GEN
SELECT actor_id, first_name, last_name
FROM actor 
WHERE last_name LIKE '%GEN%';

-- Part 2c: create a query to find all actors who have LI in their last name, ordered by last name and first name
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- Part 2d: create a query to display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China,
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- Part 3a: create a column in the actor table named description with data type BLOB
ALTER TABLE actor
ADD description BLOB;

-- Part 3b: delete the description column you just made 
ALTER TABLE actor
DROP COLUMN description;

-- Part 4a: list last names of actors as well as how many actors have that name
SELECT last_name, COUNT(last_name) as 'Number of Actors'
FROM actor
GROUP BY last_name;

-- Part 4b: the same as 4a, but only for last names with a value greater than 2
SELECT last_name, COUNT(last_name) as 'Number of Actors'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

-- Part 4c: write a query to fix Groucho Williams to Harpo Williams in actor table
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- Part 4d: Change anyone whose name is Harpo into Groucho
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';

-- Part 5a: Write a query for the schema of the address table
-- SHOW CREATE TABLE address;
DESCRIBE sakila.address;

-- Part 6a: Use join to display the first and last names and address of each staff member.
SELECT staff.first_name, staff.last_name, address.address
FROM staff LEFT JOIN address
USING (address_id);

-- Part 6b: Use join to display the total amount rung by each staff member in August 2005
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS 'Total'
FROM staff LEFT JOIN payment
USING (staff_id)
WHERE payment.payment_date LIKE '2005-08-%'
GROUP BY staff.first_name, staff.last_name;

-- Part 6c: Use inner join to list each film and the number of actors in that film.
SELECT film.title, COUNT(film_actor.actor_id) AS 'Number_Actors'
FROM film INNER JOIN film_actor
USING (film_id)
GROUP BY film_id;

-- Part 6d: find the number of copies of Hunchback Impossible in the system.
SELECT film.title, COUNT(inventory.film_id) AS 'Number'
FROM film INNER JOIN inventory
USING (film_id)
WHERE film.title = 'HUNCHBACK IMPOSSIBLE'
GROUP BY film_id;

-- Part 6e: list total paid by each customer and list it alphabetically by customer's last name.
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Amount Paid'
FROM customer LEFT JOIN payment
USING (customer_id)
GROUP BY customer_id
ORDER BY customer.last_name;

-- Part 7a: find film titles beginning in K and Q in English
SELECT title 
FROM film
WHERE language_id =(SELECT language_id FROM language WHERE name = 'English')
AND (title LIKE 'K%' OR title LIKE 'Q%');

-- Part 7b: Display all actors who appear in film Alone Trip
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title = 'ALONE TRIP'));

-- Part 7c: Display names and emails of Canadian customers using joins
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id FROM address WHERE city_id IN (SELECT city_id FROM city WHERE country_id IN (SELECT country_id FROM country WHERE country = 'Canada')));

-- Part 7d: Display names of films which are family films
SELECT title
FROM film 
WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id IN (SELECT category_id FROM category WHERE name = 'Family'));

-- Part 7e: Display the most frequently rented films in descending order
SELECT title, COUNT(film.film_id) as 'total'
FROM film
JOIN inventory ON (film.film_id = inventory.film_id)
JOIN rental ON (rental.inventory_id = inventory.inventory_id)
GROUP BY title
ORDER BY total DESC;

-- Part 7f: Display how much business each store brought in
SELECT store.store_id, SUM(payment.amount) AS 'total'
FROM store
JOIN staff ON (store.store_id = staff.store_id)
JOIN payment ON (staff.staff_id = payment.staff_id)
GROUP BY store_id;

-- Part 7g: Display for each store its store id, country, and city
SELECT store.store_id, country.country, city.city
FROM store
JOIN address ON (store.address_id = address.address_id)
JOIN city ON (address.city_id = city.city_id)
JOIN country ON (city.country_id = country.country_id)
GROUP BY store_id;

-- Part 7h: Display the top five genres of gross revenue in descending order
SELECT category.name, SUM(payment.amount) AS 'total'
FROM category
JOIN film_category USING (category_id)
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN payment USING (rental_id)
GROUP BY name
ORDER BY total DESC
LIMIT 5;

-- Part 8a: find an easy way of viewing the top five genres by gross revenue
CREATE VIEW TopFive AS
SELECT category.name AS "Top Five", SUM(payment.amount) AS "Gross"
FROM category
JOIN film_category USING (category_id)
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN payment USING (rental_id)
GROUP BY name
ORDER BY Gross DESC
LIMIT 5;

-- Part 8b: how would you display the view that you created in 8a?
SELECT * FROM TopFive;

-- Part 8c: delete the top_five_genres
DROP VIEW TopFive;
