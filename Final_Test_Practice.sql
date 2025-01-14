USE mavenmovies;

-- 1. Danh sách nhân viên với thông tin chi tiết
SELECT first_name, last_name, email, store_id
FROM staff;

-- 2. Số lượng hàng tồn kho tại mỗi cửa hàng
SELECT store_id, COUNT(*) AS inventory_count
FROM inventory
GROUP BY store_id;

-- 3. Số lượng khách hàng đang hoạt động tại mỗi cửa hàng
SELECT store_id, COUNT(*) AS active_customers
FROM customer
WHERE active = 1
GROUP BY store_id;

-- 4. Số lượng email khách hàng
SELECT COUNT(email) AS total_customer_emails
FROM customer;

-- 5_1. Số lượng tiêu đề phim duy nhất tại mỗi cửa hàng
SELECT store_id, COUNT(DISTINCT film_id) AS unique_films
FROM inventory
GROUP BY store_id;

-- 5_2. Số lượng thể loại phim duy nhất
SELECT COUNT(DISTINCT category.name) AS unique_categories
FROM category
JOIN film_category ON category.category_id = film_category.category_id;

-- 6. Chi phí thay thế phim
SELECT 
    MIN(replacement_cost) AS least_expensive,
    MAX(replacement_cost) AS most_expensive,
    AVG(replacement_cost) AS average_cost
FROM film;

-- 7. Thanh toán trung bình và thanh toán cao nhất
SELECT 
    AVG(amount) AS average_payment,
    MAX(amount) AS max_payment
FROM payment;

-- 8. Danh sách khách hàng với số lượng thuê
SELECT customer_id, COUNT(rental_id) AS rental_count
FROM rental
GROUP BY customer_id
ORDER BY rental_count DESC;

-- 9. Danh sách quản lý cửa hàng với địa chỉ đầy đủ
SELECT 
    CONCAT(staff.first_name, ' ', staff.last_name) AS manager_name,
    store.store_id,
    address.address, 
    address.district, 
    city.city, 
    country.country
FROM store
JOIN staff ON store.manager_staff_id = staff.staff_id
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;

-- 10. Danh sách chi tiết hàng tồn kho
SELECT 
    inventory.store_id,
    inventory.inventory_id,
    film.title AS film_name,
    film.rating,
    film.rental_rate,
    film.replacement_cost
FROM inventory
JOIN film ON inventory.film_id = film.film_id;

-- 11. Tổng quan số lượng hàng tồn kho theo rating tại từng cửa hàng
SELECT 
    store_id,
    rating,
    COUNT(*) AS inventory_count
FROM inventory
JOIN film ON inventory.film_id = film.film_id
GROUP BY store_id, rating;

-- 12. Tổng quan chi phí thay thế theo thể loại và cửa hàng
SELECT 
    store_id,
    category.name AS category,
    COUNT(*) AS film_count,
    AVG(replacement_cost) AS avg_replacement_cost,
    SUM(replacement_cost) AS total_replacement_cost
FROM inventory
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY store_id, category.name;

-- 13. Danh sách khách hàng với thông tin chi tiết
SELECT 
    CONCAT(first_name, ' ', last_name) AS customer_name,
    store_id,
    active,
    address.address, city.city, country.country
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;

-- 14. Tổng chi tiêu của khách hàng
SELECT 
    CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
    COUNT(rental.rental_id) AS total_rentals,
    SUM(payment.amount) AS total_spent
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.customer_id
ORDER BY total_spent DESC;

-- 15. Danh sách cố vấn và nhà đầu tư
SELECT 
    CONCAT(first_name, ' ', last_name) AS advisor_name, 
    'Advisor' AS role, 
    NULL AS company
FROM advisor
UNION ALL
SELECT 
    CONCAT(first_name, ' ', last_name) AS investor_name,
    'Investor' AS role, 
    company_name
FROM investor;

-- 16. Tỷ lệ diễn viên đoạt giải có phim
WITH awarded_actors AS (
    SELECT actor_id, COUNT(DISTINCT awards) AS award_count
    FROM actor_award
    GROUP BY actor_id
),
actor_films AS (
    SELECT DISTINCT actor_id
    FROM film_actor
)
SELECT 
    award_count,
    COUNT(CASE WHEN actor_id IN (SELECT actor_id FROM actor_films) THEN 1 ELSE NULL END) / COUNT(*) * 100 AS percentage_with_films
FROM awarded_actors
GROUP BY award_count;


/*
1.	We will need a list of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. 
*/ 


/*
2.	We will need separate counts of inventory items held at each of your two stores. 
*/ 


/*
3.	We will need a count of active customers for each of your stores. Separately, please. 
*/


/*
4.	In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. 
*/


/*
5_1.	We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. Please provide a count of unique film titles 
you have in inventory at each store.
*/


/*
5_2. And then provide a count of the unique categories of films you provide.
*/


/*
6.	We would like to understand the replacement cost of your films. 
Please provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
*/


/*
7.	We are interested in having you put payment monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
*/


/*
8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals 
they have made all-time, with your highest volume customers at the top of the list.
*/


/* 
9. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

	
/*
10.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/


/* 
11.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/


/* 
12. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 


/*
13.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/


/*
14.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

    
/*
15. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/


/*
16. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

