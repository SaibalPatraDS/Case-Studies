/* ANALYSIS FILE */


-- 1. 1.what is total amount each customer spent on zomato ?

/*
merge `products` and `sales` table on `product_id` and calculate total spent by using group by on 'user_id'
*/

SELECT s.user_id,
       '$ ' || SUM(p.price) AS total_spent
FROM zomato.products p
JOIN zomato.sales s
ON p.product_id = s.product_id
GROUP BY s.user_id
ORDER BY s.user_id;



--2.How many days has each customer visited zomato?

/*
COUNT `created_date` using GROUP BY on 'user_id'
*/

SELECT user_id,
       COUNT(created_date) AS n_visits
FROM zomato.sales
GROUP BY user_id
ORDER BY user_id;



--3.what was the first product purchased by each customer?

/*
merge 'products' and 'sales' table on `product_id` and
rank -> created_date, using PARTITION BY user_id (for each user) 
and select user_id and product_name from sales and products table respectively.
*/

SELECT user_id,
       product_name
FROM (	   
	SELECT s.user_id,
		   s.created_date,
		   p.product_name,
		   ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY created_date) AS rn
	FROM zomato.sales s
	JOIN zomato.products p
	ON s.product_id = p.product_id) x
WHERE rn = 1;



-- 4.what is most purchased item on menu & how many times was it purchased by all customers ?

/*
 COUNT total no of purchase for each products, based on user_id and user OVER() function.
*/

WITH most_purchase AS (
	SELECT user_id,
		   product_id,
		   COUNT(product_id) AS n_times_purchased
	FROM zomato.sales
	GROUP BY user_id, product_id
	ORDER BY user_id),

ranking AS (
	SELECT user_id,
	       product_id AS products,
		   n_times_purchased,
	       RANK() OVER(PARTITION BY user_id ORDER BY n_times_purchased DESC) AS most_purchased
	FROM most_purchase
)

SELECT user_id,
       p.product_name,
	   n_times_purchased
FROM ranking r
JOIN zomato.products p
ON p.product_id = r.products
WHERE most_purchased = 1;

-- SELECT * FROM zomato.sales
-- WHERE user_id = 3
-- ORDER BY product_id;



-- 5.which item was most popular for each customer?


/*
 COUNT total no of purchase for each products, based on user_id and user OVER() function.
*/

WITH most_purchase AS (
	SELECT user_id,
		   product_id,
		   COUNT(product_id) AS n_times_purchased
	FROM zomato.sales
	GROUP BY user_id, product_id
	ORDER BY user_id),

ranking AS (
	SELECT user_id,
	       product_id AS products,
		   n_times_purchased,
	       RANK() OVER(PARTITION BY user_id ORDER BY n_times_purchased DESC) AS most_purchased
	FROM most_purchase
)

SELECT user_id,
       p.product_name
FROM ranking r
JOIN zomato.products p
ON p.product_id = r.products
WHERE most_purchased = 1;



-- 6.which item was purchased first by customer after they become a member ?

/*
merge `goldusers_signup` with `sales` on 'user_id' column and 
then merge the resulting table with `products` on 'product_id' column 
and condition is 'created_date' > 'signup_date'
And Rank the products as per order date for each user.
*/ 

SELECT user_id,
       product_name 
FROM (	   
	SELECT gs.user_id,
		   p.product_name,
		   TO_CHAR(gs.signup_date, 'MM-DD-YYYY'),
		   TO_CHAR(s.created_date,'MM-DD-YYYY') ,
		   RANK() OVER(PARTITION BY gs.user_id ORDER BY created_date) AS rnk
	FROM zomato.goldusers_signup gs
	JOIN zomato.sales s 
	ON gs.user_id = s.user_id
	JOIN zomato.products p
	ON p.product_id = s.product_id
	WHERE gs.signup_date < s.created_date
	ORDER BY gs.user_id) x
WHERE rnk = 1;



-- 7. which item was purchased just before the customer became a member?

/*
merge `goldusers_signup` with `sales` on 'user_id' column and 
then merge the resulting table with `products` on 'product_id' column 
and condition is 'created_date' < 'signup_date'
And Rank the products as per order date(DESC) for each user. 
And filter when rank = 1.
*/


SELECT user_id,
       product_name 
FROM (	   
	SELECT gs.user_id,
		   p.product_name,
		   TO_CHAR(gs.signup_date, 'MM-DD-YYYY'),
		   TO_CHAR(s.created_date,'MM-DD-YYYY') ,
		   RANK() OVER(PARTITION BY gs.user_id ORDER BY created_date DESC) AS rnk
	FROM zomato.goldusers_signup gs
	JOIN zomato.sales s 
	ON gs.user_id = s.user_id
	JOIN zomato.products p
	ON p.product_id = s.product_id
	WHERE gs.signup_date > s.created_date
	ORDER BY gs.user_id) x
WHERE rnk = 1;

-- SELECT * FROM zomato.users;
-- SELECT * FROM zomato.goldusers_signup;
-- SELECT * FROM zomato.sales
-- WHERE user_id = 2;

















































































































































