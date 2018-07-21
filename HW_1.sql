SELECT 
    first_name, last_name
FROM
    actor;
    
    
SELECT CONCAT(last_name,', ',first_name) AS Actor_Name
  FROM actor ORDER BY Actor_Name;
  
-- ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 

SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';
    

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE  '%GEN%'
    

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE  '%LI%'
ORDER BY last_name DESC, first_name DESC;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT 
    country_id, country
FROM
    country
WHERE
    'Afghanistan' or 'Bangladesh' or 'China' IN (country);
    
-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(15) AFTER first_name;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor MODIFY middle_name blob;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor drop middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
Select last_name, count(last_name) as last_name_count
from actor
groupby last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
Select last_name, count(last_name) as last_name_count
from actor
groupby last_name
having count(last_name > 1);

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
SELECT 
    actor_id
FROM
    actor
WHERE
    first_name = 'Groucho' and last_name = 'williams';
    
 UPDATE actor 
    SET first_name = 'Harpo'
	WHERE actor_id = 172;
    
* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

-- check if first name with HARPO

SELECT first_name, last_name
FROM actor
WHERE
   first_name = 'HARPO';
   


UPDATE actor

SET first_name = 'GROUCHO'
WHERE   first_name = 'HARPO';


--  * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?


DESC sakila.address;

SHOW CREATE TABLE sakila.address;


-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

-- check staff for cols to join and common col id


SELECT *
FROM staff;

SELECT *
FROM address;  


SELECT first_name, last_name, address
FROM staff
LEFT JOIN address
USING (address_id); -- ON staff.address_id = address.address_id


-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.


SELECT *
FROM staff;


SELECT *
FROM payment;

SELECT lft.staff_id, first_name, last_name, sum(amount) AS TOTAL_AMOUNT
FROM staff as lft
INNER JOIN payment as rit

ON lft.staff_id = rit.staff_id
WHERE payment_date LIKE '2005-08%'

GROUP BY staff_id;



   -- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
   
SELECT *
FROM film_actor;

SELECT * 
FROM film;


SELECT title, count(actor_id) AS NUM_ACTORS 
FROM film
INNER JOIN  film_actor
USING(film_id)
GROUP BY (actor_id);  


-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT *
FROM inventory;

SELECT *
FROM inventory;

SELECT lt.film_id, rt.title, count(lt.film_id)
FROM inventory AS lt
INNER JOIN film AS rt
USING(film_id)
GROUP BY lt.film_id
HAVING rt.title = 'Hunchback Impossible';


-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total
--     paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, sum(p.amount) AS `Total Paid`
FROM customer c
JOIN payment p 
ON c.customer_id= p.customer_id
GROUP BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
--     As an unintended consequence, films starting with the letters `K` and `Q` have
--     also soared in popularity. Use subqueries to display the titles of movies
--     starting with the letters `K` and `Q` whose language is English. 

SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
(
SELECT title 
FROM film 
WHERE language_id = 1
);

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
Select actor_id
FROM film_actor
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));

-- 7c. You want to run an email marketing campaign in Canada, for which you 
--     will need the names and email addresses of all Canadian customers. 
--     Use joins to retrieve this information.

SELECT cus.first_name, cus.last_name, cus.email 
FROM customer cus
JOIN address a 
ON (cus.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada';

-- * 7d. Sales have been lagging among young families, and you wish
--       to target all family movies for a promotion. Identify all movies 
--       categorized as famiy films.

SELECT title, description FROM film 
WHERE film_id IN
(
SELECT film_id FROM film_category
WHERE category_id IN
(
SELECT category_id FROM category
WHERE name = "Family"
));

-- 7e. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(rental_id) AS 'Times Rented'
FROM rental r
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film f
ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY `Times Rented` DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id; 

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a 
ON (s.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id);


--  7h. List the top five genres in gross revenue in descending order. 
--      (**Hint**: you may need to use the following tables: category,
--       film_category, inventory, payment, and rental.)

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

--  8a. In your new role as an executive, you would like to have an easy 
--      way of viewing the Top five genres by gross revenue. Use the solution
--      from the problem above to create a view. If you haven't solved 7h, you
--      can substitute another query to create a view.

CREATE VIEW genre_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
  	
--  8b. How would you display the view that you created in 8a?

SELECT * FROM genre_revenue;

--  8c. You find that you no longer need the view `top_five_genres`. 
--      Write a query to delete it.

DROP VIEW genre_revenue;