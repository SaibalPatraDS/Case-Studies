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

Feel free to use these queries for your analysis on the Airbnb NYC dataset. Happy querying!
Make sure to save this content in a file named `README.md` in your desired repository or project. 
This README provides a brief explanation of each query, making it easier for others to understand the purpose of each query and how to use them in their analyses.








