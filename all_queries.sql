-- 1a. Display the first and last names of all actors from the table actor. 
USE sakila;
SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. 
USE sakila;
SELECT concat(first_name, " ", last_name) AS Actor_Name
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
USE sakila;
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
USE sakila;
SELECT last_name
FROM actor
WHERE last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
USE sakila;
SELECT last_name
FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
USE sakila;
SELECT country_id, country
FROM country 
WHERE country IN 
('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
USE sakila;
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(40);

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
USE sakila;
ALTER TABLE actor
MODIFY middle_name BLOB;

-- 3c. Now delete the middle_name column.
USE sakila;
ALTER TABLE actor
DROP middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
USE sakila;
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
USE sakila;
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >=2;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
USE sakila;
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
USE sakila;
UPDATE actor
SET first_name =
    CASE 
    WHEN first_name = 'HARPO'
    THEN 'GROUCHO'
    ELSE 'MUCHO GROUCHO'
    END 
WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? 
SHOW CREATE TABLE sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
USE sakila;
SELECT first_name, last_name, address
FROM staff s 
INNER JOIN address a
ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 
USE sakila;
SELECT first_name, last_name, SUM(amount)
FROM staff as s
INNER JOIN payment as p
ON s.staff_id = p.staff_id
GROUP BY p.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
USE sakila;
SELECT title, COUNT(actor_id)
FROM film as f
INNER JOIN film_actor as fiac 
ON f.film_id = fiac.film_id
GROUP BY title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
USE sakila;
SELECT title, COUNT(inventory_id)
FROM film as f
INNER JOIN inventory as i 
ON f.film_id = i.film_id
WHERE title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
USE sakila;
SELECT last_name, first_name, SUM(amount)
FROM payment as pay 
JOIN customer as cust 
ON pay.customer_id = cust.customer_id
GROUP BY pay.customer_id
ORDER BY last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
USE sakila;
SELECT title
FROM film
WHERE language_id in 
    (SELECT language_id
    FROM language
    WHERE name = "English")
AND title LIKE "K%" OR title LIKE "Q%";

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
USE sakila;
SELECT last_name, first_name
FROM actor
WHERE actor_id in 
    (SELECT actor_id
    FROM film_actor
    WHERE film_id in
        (SELECT film_id
        FROM film
        WHERE title = "Alone Trip"));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
USE sakila;
SELECT last_name, first_name, email
FROM country as co
JOIN city as ci 
ON co.country_id = ci.country_id
JOIN address as adr 
ON ci.city_id = adr.city_id
JOIN customer as cust
ON adr.address_id = cust.address_id
WHERE country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
USE sakila;
SELECT title, category
FROM film_list
WHERE category = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
USE sakila;
SELECT invt.film_id, ft.title, COUNT(rent.inventory_id)
FROM inventory as invt 
JOIN rental as rent
ON invt.inventory_id = rent.inventory_id
JOIN film_text as ft
ON invt.film_id = ft.film_id
GROUP BY rent.inventory_id
ORDER BY COUNT(rent.inventory_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
USE sakila;
SELECT store.store_id, SUM(amount)
FROM store
JOIN staff
ON store.store_id = staff.store_id
JOIN payment as pay
ON pay.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);

-- 7g. Write a query to display for each store its store ID, city, and country.
USE sakila;
SELECT st.store_id, city, country
FROM store as st
JOIN customer as cust 
ON st.store_id = cust.store_id
JOIN staff as stf 
ON st.store_id = stf.store_id
JOIN address as addr 
ON cust.address_id = addr.address_id
JOIN city as ct 
ON addr.city_id = ct.city_id
JOIN country as cou
ON ct.country_id = cou.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
USE sakila;
SELECT cat.name, SUM(amount)
FROM category as cat 
JOIN film.category as fica 
ON cat.category_id = fica.category_id
JOIN inventory invt
ON fica.film_id = invt.film_id
JOIN rental re
ON invt.inventory_id = re.inventory_id
JOIN payment pay
ON re.rental_id = pay.rental_id
GROUP BY cat.name
ORDER BY SUM(amount) DESC limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
USE sakila;
CREATE VIEW top_five_genres_by_gross_revenue 

SELECT cat.name, SUM(amount)
FROM category as cat
JOIN film_category as fica 
ON cat.category_id = fica.category_id
JOIN inventory invt 
ON fica.film_id = invt.film_id
JOIN rental re
ON invt.inventory_id = re.inventory_id
JOIN payment pay
ON re.rental_id = pay.rental_id
GROUP BY cat.name
ORDER BY sum(amount) DESC limit 5;

-- 8b. How would you display the view that you created in 8a?
USE sakila;
SELECT *
FROM top_five_genres_by_gross_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
USE sakila;
DROP VIEW top_five_genres_by_gross_revenue;
