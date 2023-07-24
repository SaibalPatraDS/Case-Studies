/* Solution */


-- Question 1 :
/*
Write an SQL query to find the top 10 hosts 
with the highest number of listings (calculated_host_listings_count) 
in each neighbourhood_group, along with the number of listings for each host.
*/

SELECT host_id, 
       COUNT(calculated_host_listings_count) AS n_listings
FROM airbnb_nyc.fk_pid_master_data
GROUP BY neighbourhood_group, host_id
ORDER BY n_listings DESC
LIMIT 10;



-- Question 2 :
/*
Write an SQL query to calculate 
the average price and the median price 
of each room type (room_type) in the dataset.
*/

SELECT room_type, 
       AVG(price) AS avg_price,
	   PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY price) AS median_price
FROM airbnb_nyc.fk_pid_master_data
GROUP BY room_type;



-- Question 3 :
/*
Write an SQL query 
to find the neighbourhood_group 
with the highest average number of reviews per month (reviews_per_month).
*/

SELECT neighbourhood_group,
       ROUND(AVG(reviews_per_month),2) AS avg_monthly_reviews
FROM airbnb_nyc.fk_pid_master_data
GROUP BY neighbourhood_group;




-- Question 4 :
/*
Write an SQL query to retrieve the names and IDs of the hosts 
who have more than one listing and have not received any reviews in the last 6 months.
*/

SELECT * 
FROM (
	SELECT host_id, host_name,
		   COUNT(calculated_host_listings_count) AS n_listings_counts,
		   EXTRACT(MONTH FROM last_review) AS last_rev_months
	FROM airbnb_nyc.fk_pid_master_data
	GROUP BY host_id, host_name,last_review) x
WHERE x.n_listings_counts > 1 AND x.last_rev_months >= 6;




-- Question 5 :
/*
Write an SQL query to find the number of listings (room_type) in each neighbourhood_group, 
where the minimum_nights required is less than or equal to 3.
*/


SELECT room_type,
       neighbourhood_group,
	   COUNT(calculated_host_listings_count) n_listings_counts
FROM airbnb_nyc.fk_pid_master_data
WHERE minimum_nights <= 3
GROUP BY room_type, neighbourhood_group
ORDER BY neighbourhood_group;





































































