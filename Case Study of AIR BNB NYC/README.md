# SQL Queries for Airbnb NYC Dataset

This repository contains SQL queries to perform various analyses on the Airbnb NYC dataset. The dataset is stored in a table named `fk_pid_master_data`.

## Question 1: Top 10 Hosts with Highest Number of Listings

```sql
SELECT host_id, 
       COUNT(calculated_host_listings_count) AS n_listings
FROM airbnb_nyc.fk_pid_master_data
GROUP BY neighbourhood_group, host_id
ORDER BY n_listings DESC
LIMIT 10;
```

This query finds the top 10 hosts with the highest number of listings (calculated_host_listings_count) in each neighbourhood_group, along with the number of listings for each host.

## Question 2: Average and Median Price for Each Room Type

```sql
SELECT room_type, 
       AVG(price) AS avg_price,
	   PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY price) AS median_price
FROM airbnb_nyc.fk_pid_master_data
GROUP BY room_type;
```
This query calculates the average price and median price of each room type (room_type) in the dataset.

## Question 3: Neighbourhood Group with Highest Average Number of Reviews per Month

```sql
SELECT neighbourhood_group,
       ROUND(AVG(reviews_per_month),2) AS avg_monthly_reviews
FROM airbnb_nyc.fk_pid_master_data
GROUP BY neighbourhood_group;
```

This query finds the neighbourhood_group with the highest average number of reviews per month (reviews_per_month).


## Question 4: Hosts with Multiple Listings and No Reviews in the Last 6 Months

```sql
SELECT * 
FROM (
	SELECT host_id, host_name,
		   COUNT(calculated_host_listings_count) AS n_listings_counts,
		   EXTRACT(MONTH FROM last_review) AS last_rev_months
	FROM airbnb_nyc.fk_pid_master_data
	GROUP BY host_id, host_name,last_review) x
WHERE x.n_listings_counts > 1 AND x.last_rev_months >= 6;
```

This query retrieves the names and IDs of the hosts who have more than one listing and have not received any reviews in the last 6 months.

## Question 5: Number of Listings in Each Neighbourhood Group with Minimum Nights Less Than or Equal to 3

```sql
SELECT room_type,
       neighbourhood_group,
	   COUNT(calculated_host_listings_count) n_listings_counts
FROM airbnb_nyc.fk_pid_master_data
WHERE minimum_nights <= 3
GROUP BY room_type, neighbourhood_group
ORDER BY neighbourhood_group;
```

This query finds the number of listings (room_type) in each neighbourhood_group, where the minimum_nights required is less than or equal to 3.



## Question 6: Top 5 Neighbourhoods with the Highest Average Price (More than 50 Listings)

```sql
-- Write an SQL query to find the top 5 neighbourhoods with the highest average price, considering only neighbourhoods with more than 50 listings.
SELECT neighbourhood_group,
       ROUND(AVG(price),2) AS avg_price,
	   COUNT(calculated_host_listings_count) n_listings_counts
FROM airbnb_nyc.fk_pid_master_data
GROUP BY neighbourhood_group
HAVING COUNT(calculated_host_listings_count) > 50
ORDER BY avg_price DESC
LIMIT 5;
```

## Question 7: Average Availability for Each Neighbourhood Group
```sql
-- Write an SQL query to calculate the average availability for each neighbourhood_group, sorting the results in descending order of the average availability.
SELECT neighbourhood_group, 
       ROUND(AVG(availability_365),0) avg_availability
FROM airbnb_nyc.fk_pid_master_data
GROUP BY neighbourhood_group
ORDER BY avg_availability DESC;
```

## Question 8: Hosts with at Least 10 Listings and Highest Overall Reviews per Month

```sql
-- Write an SQL query to find the hosts who have at least 10 listings and the highest overall reviews per month, along with their average price and the total number of reviews they have received.
SELECT host_id,
       ROUND(AVG(price),2) avg_price,
	   COUNT(number_of_reviews) AS n_reviews,
	   COUNT(reviews_per_month) AS n_reviews_p_month
FROM airbnb_nyc.fk_pid_master_data
WHERE calculated_host_listings_count >= 10
GROUP BY host_id
ORDER BY n_reviews_p_month DESC
LIMIT 1;
```

## Question 9: Percentage of Listings with Reviews in the Last 3 Months

```sql
-- Write an SQL query to calculate the percentage of listings that have received reviews in the last 3 months, based on last_review.
WITH last_3_month AS (
	SELECT room_type,
		   COUNT(*) AS n_reviews
	FROM airbnb_nyc.fk_pid_master_data
	WHERE EXTRACT(MONTH FROM last_review) <= 3
	GROUP BY room_type)

SELECT a.room_type,
       ROUND(100 * b.n_reviews/COUNT(a.number_of_reviews)::NUMERIC,2) || '%' AS percent_ratings
FROM airbnb_nyc.fk_pid_master_data a
JOIN last_3_month b
ON a.room_type = b.room_type
GROUP BY a.room_type, b.n_reviews;
```

## Question 10: Neighbourhood Group with the Highest Ratio of Average Price to Average Number of Reviews per Month

```sql
-- Write an SQL query to find the neighbourhood_group with the highest ratio of average price to average number of reviews per month.
SELECT neighbourhood_group,
       ROUND(AVG(price)/AVG(reviews_per_month), 2) AS ratio_of_price_to_reviews
FROM airbnb_nyc.fk_pid_master_data
GROUP BY neighbourhood_group 
ORDER BY ratio_of_price_to_reviews DESC
LIMIT 1;
```

Feel free to use these SQL queries to analyze the Airbnb NYC dataset. Each query is accompanied by its description, making it easier for others to understand the purpose of each query and how to use them in their analyses. Happy querying!



Make sure to save this content in a file named `README.md` in your desired repository or project. This README provides an organized list of the SQL queries, along with their descriptions, making it easier for others to understand the purpose of each query and how to use them in their analyses.
