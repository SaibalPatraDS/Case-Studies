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




-- 8. what is total orders and amount spent for each member before they become a member?

/*
 1. select only goldusers.
 2. join `sales` and `goldusers_signup` on 'user_id', condition -> created_date < signup_date
 3. Count(product_id) for total_orders for each users
 4. Join the result with `products` column on 'product_id'
 5. Sum(price) for total_price spend.
*/

SELECT s.user_id,
       COUNT(s.product_id) AS total_products,
	   SUM(p.price) AS total_spent
FROM zomato.goldusers_signup gs
JOIN zomato.sales s
ON gs.user_id = s.user_id
JOIN zomato.products p
ON p.product_id = s.product_id
WHERE s.created_date < gs.signup_date
GROUP BY s.user_id;



-- 9. If buying each product generates points for eg 5rs=2 zomato point 
--   and each product has different purchasing points for eg for p1 5rs=1 zomato point,for p2 10rs=1 zomato point and p3 5rs=1 zomato point, 
--   calculate points collected by each customer and for which product most points have been given till now.


-- SELECT * FROM zomato.products;
/*
  1. Will calculate total coins for each products and create new CTE -> `coins`,
  2. merge both `sales` and `coins` table on 'product_id' 
  3. and for each user calculate total coins for each items
*/

WITH coins AS(
	SELECT product_id,
	       product_name,
	       price,
	       CASE WHEN product_name = 'p1' THEN price::INTEGER/5 * 1 
	            WHEN product_name = 'p2' THEN price::INTEGER/10 * 1
	            WHEN product_name = 'p3' THEN price::INTEGER/5 * 1
	       END AS coin
	FROM zomato.products
),

-- SELECT * FROM coins;

sum_coins AS (
	SELECT s.user_id,
		   c.product_id,
		   SUM(c.coin) AS total_coins,
		   RANK() OVER(PARTITION BY s.user_id ORDER BY SUM(c.coin) DESC) AS rnk
	FROM zomato.sales s
	JOIN coins c
	ON c.product_id = s.product_id
	GROUP BY s.user_id, c.product_id
	ORDER BY s.user_id) 

-- SELECT * FROM sum_coins;

SELECT user_id,
	   product_id,
	   total_coins,
	   SUM(total_coins) OVER(PARTITION BY user_id) AS total_coin
FROM sum_coins;

-- SELECT 101/5::NUMERIC;



-- WITH coins AS (
--   SELECT product_id,
--          product_name,
--          price,
--          CASE 
--            WHEN product_name = 'p1' THEN price::INTEGER / 5
--            WHEN product_name = 'p2' THEN price::INTEGER / 10
--            WHEN product_name = 'p3' THEN price::INTEGER / 5
--          END AS coin
--   FROM zomato.products
-- ),
-- sum_coins AS (
--   SELECT s.user_id,
--          c.product_id,
--          SUM(c.coin) AS total_coins,
--          RANK() OVER(PARTITION BY s.user_id ORDER BY SUM(c.coin) DESC) AS rnk
--   FROM zomato.sales s
--   JOIN coins c
--   ON c.product_id = s.product_id
--   GROUP BY s.user_id, c.product_id
-- )

-- SELECT user_id,
--        product_id,
--        total_coins
-- FROM sum_coins;



-- 10. In the first year after a customer joins the gold program (including the join date ) irrespective of 
--     what customer has purchased earn 5 zomato points for every 10rs spent 
--     who earned more more 1 or 2 what int earning in first yr ? 1zp = 2rs

/*
  1. merge `goldusers_signup` and `sales` table on 'user_id'
  2. filter the purchases where created_date - signup_date <= 1 year
  3. now merge the resulting column with `products` on 'product_id'
  4. Now calculate total coins whenever there is a purchase, by using the formula, 1 zp = 2 rs
*/
WITH first_yr_pur AS(
	SELECT gs.user_id,
		   p.product_name,
		   p.price,
		   p.price::INTEGER/2 * 1 AS zomato_points,
		   EXTRACT (YEAR FROM s.created_date) -  EXTRACT (YEAR FROM gs.signup_date) AS year_diff
	FROM zomato.goldusers_signup gs
	JOIN zomato.sales s
	ON gs.user_id  = s.user_id
	JOIN zomato.products p
	ON p.product_id = s.product_id
	WHERE s.created_date > gs.signup_date)
-- GROUP BY gs.user_id;


SELECT user_id,
--        product_name,
	   SUM(zomato_points) AS total_zp
FROM first_yr_pur
WHERE year_diff <= 1
GROUP BY user_id;

/*
  Conclusion : User 2 has more zomato points for first year after taking the gold-membership.
*/



-- SELECT * FROM zomato.goldusers_signup;



-- 11. rnk all transaction of the customers

/*
  1. using rank function to rank and also selecting the user_id, product_name and created_date in correct 'DD-MM-YYYY' format
  2. And merging both `sales` and `purchase` table on 'product_id' column.
*/

SELECT s.user_id,
       p.product_name,
	   TO_CHAR(s.created_date, 'DD-MM-YYYY') AS purchased_date,
	   RANK() OVER(PARTITION BY s.user_id ORDER BY s.created_date) AS rnk_of_purchase
FROM zomato.sales s
JOIN zomato.products p
ON s.product_id = p.product_id;


-- 12. rank all transaction for each member whenever they are zomato gold member for every non gold member transaction mark as na

/* 
  1. select all trasactions made by customers,
  2. Rank only those transactions when created_date > signup_date
  3. Merge both tables `goldusers_signup` and `sales` on 'user_id'
  4. Rank using CASE WHEN Statements.
*/

WITH ranking AS ( 
	SELECT u.user_id,
		   s.created_date,
		   CASE WHEN s.created_date > gs.signup_date THEN 'G'
				WHEN s.created_date < gs.signup_date THEN 'NG'
		   ELSE 'na' END AS trans_cat
	FROM zomato.goldusers_signup gs
	JOIN zomato.users u
	USING (user_id)
	JOIN zomato.sales s
	USING (user_id))

SELECT user_id, 
       created_date,
       trans_cat,
	   RANK() OVER(PARTITION BY user_id,trans_cat ORDER BY created_date) AS rnk
FROM ranking;

-- SELECT * FROM zomato.users;



-- WITH ranking AS ( 
-- 	SELECT gs.user_id,
-- 		   s.created_date,
-- 		   CASE WHEN s.created_date > gs.signup_date THEN 'G'
-- 				WHEN s.created_date < gs.signup_date THEN 'NG'
-- 				ELSE 'na' END AS trans_cat
-- 	FROM zomato.goldusers_signup gs
-- 	JOIN zomato.sales s
-- 	ON gs.user_id = s.user_id AND s.created_date >= gs.signup_date
-- )

-- SELECT user_id, 
--        created_date,
--        trans_cat,
--        RANK() OVER(PARTITION BY user_id, trans_cat ORDER BY created_date) AS rnk
-- FROM ranking;

