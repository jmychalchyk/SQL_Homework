use sakila;

-- ## Instructions

-- * 1a. Display the first and last names of all actors from the table `actor`.
Select first_name,last_name from actor;
-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
Select ucase(concat(first_name , ' ' , last_name)) as Actor_Name  from actor;
-- * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
Select Actor_id, first_name,last_name from actor where first_name like 'Joe';
-- * 2b. Find all actors whose last name contain the letters `GEN`:
select * from actor where last_name like '%gen%';
-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select * from actor where last_name like '%LI%' order by last_name, first_name;
-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country where country in('Afghanistan', 'Bangladesh','China');
-- * 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor ADD COLUMN description blob ;
-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor DROP COLUMN description;
-- * 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name)  from actor group by last_name;
-- * 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name)  from actor group by last_name having count(last_name)>1;
-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor set first_name = 'HARPO' where last_name = 'williams' and first_name = 'groucho';
-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor set first_name = 'GROUCHO' where  first_name = 'harpo';
-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
create table address(
address_id smallint auto_increment not null,
address varchar(50),
address2 varchar(50),
district varchar(20),
city_id smallint(5) not null,
postal_code varchar(10),
phone varchar(20),
location geometry,
last_update timestamp,
primary key (address_id)
);

-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select first_name, last_name, address from staff join address on staff.address_id = address.address_id;
-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select first_name, last_name, sum(amount) from staff join payment on staff.staff_id = payment.staff_id group by first_name, last_name;
-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select title , count(actor_ID) from film_actor inner join film on film_actor.film_id = film.film_id group by title;
-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select title , count(inventory_ID) from inventory inner join film on inventory.film_id = film.film_id where title ='Hunchback Impossible' group by title;
-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select first_name,last_name, sum(amount) as Total from customer join payment on customer.customer_id = payment.customer_id group by first_name, last_name order by last_name;
-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title from film  join  language on film.language_id = language.language_id where language.name = 'english' and (title like 'k%' or title like 'q%');
-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select a.first_name, a.last_name from 
	(select first_name, last_name,film_id from actor 
		join film_actor on actor.actor_id = film_actor.actor_id) as a  
	join film on a.film_id = film.film_id where title ='Alone Trip';
-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select first_name, last_name, email from customer 
	join address on customer.address_id = address.address_id 
	join city on address.city_id = city.city_id
	join country on city.country_id = country.country_id
	where country.country = 'canada';
-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

-- * 7e. Display the most frequently rented movies in descending order.

-- * 7f. Write a query to display how much business, in dollars, each store brought in.

-- * 7g. Write a query to display for each store its store ID, city, and country.

-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

-- * 8b. How would you display the view that you created in 8a?

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.