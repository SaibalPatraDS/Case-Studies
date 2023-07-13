/* ANALYSIS of Bike Rental Sharing Data */



--1. What is the overall trend in rental bike counts (cnt) over the two years?

/*
  Calculating total number of bike rented per month in each year and
  finally plotting using a line graph
*/

SELECT DISTINCT EXTRACT(YEAR FROM dteday) AS d_year,
       EXTRACT(month FROM dteday) AS d_month,
       SUM(cnt) AS total_bike_rented
FROM bike_rental.days
GROUP BY EXTRACT(YEAR FROM dteday), EXTRACT(month FROM dteday)
ORDER BY d_year;


/* visualize monthwise */

SELECT DISTINCT EXTRACT(month FROM dteday) AS d_month,
       SUM(cnt) AS total_bike_rented
FROM bike_rental.days
GROUP BY EXTRACT(month FROM dteday)
ORDER BY d_month;

/*visualize/Trend yearwise */

SELECT DISTINCT EXTRACT(YEAR FROM dteday) AS d_year,
       SUM(cnt) AS total_bike_rented
FROM bike_rental.days
GROUP BY EXTRACT(YEAR FROM dteday)
ORDER BY d_year;




--2. How does the rental bike usage (cnt) vary between weekdays and weekends?

/*
Weekend when weekday is either 0 or 6, 0 -> Sunday and 6 -> Saturday
Weekday when weekday is between 1 to 5, including both.

OR for workingday column, if it's 0 then WEEKEND, else WEEKDAY.
*/


-- SELECT CASE WHEN weekday = 0 THEN 'WEEKEND'
-- 	        WHEN weekday = 6 THEN 'WEEKEND'
-- 	        ELSE 'WEEKDAY'
-- 		END AS days,
-- 		weekday, 
-- 		workingday,
-- 		CASE WHEN workingday = 0 THEN 'WEEKEND'
-- 	        ELSE 'WEEKDAY'
-- 		END AS w_days
-- FROM bike_rental.days;


SELECT DISTINCT EXTRACT(YEAR FROM dteday) AS d_year,
       CASE WHEN weekday = 0 THEN 'WEEKEND'
	        WHEN weekday = 6 THEN 'WEEKEND'
	        ELSE 'WEEKDAY'
	   END AS days,
	   SUM(cnt) AS total_rented_bikes
FROM bike_rental.days
GROUP BY DISTINCT EXTRACT(YEAR FROM dteday), days
ORDER BY d_year;



SELECT CASE WHEN weekday = 0 THEN 'WEEKEND'
	        WHEN weekday = 6 THEN 'WEEKEND'
	        ELSE 'WEEKDAY'
	   END AS days,
	   SUM(cnt) AS total_rented_bikes
FROM bike_rental.days
GROUP BY days;



-- 3. What is the distribution of rental bike counts (cnt) across different seasons?

SELECT CASE WHEN season = 1 THEN 'Springer' 
            WHEN season = 2 THEN 'Summer'
			WHEN season = 3 THEN 'Fall'
			WHEN season = 4 THEN 'Winter'
		END AS seasons, 
       COUNT(season) cnt_season,
	   SUM(cnt) AS total_bikes_rented,
	   ROUND(SUM(cnt)/COUNT(season)::NUMERIC,0) AS daywise_rented_bikes
FROM bike_rental.days
GROUP BY seasons;




--4. How does the rental bike usage (cnt) vary with different hours of the day?

-- bar plot will be best for visualization

SELECT hr AS hours_of_day,
       SUM(cnt) AS total_bikes_rented
FROM bike_rental.hours
GROUP BY hr
ORDER BY hours_of_day;



--5. Which month has the highest average rental bike count (cnt)?

SELECT EXTRACT(MONTH FROM dteday) AS months,
       FLOOR(AVG(cnt)) AS avg_n_rented_bikes
FROM bike_rental.days
GROUP BY EXTRACT(MONTH FROM dteday)
ORDER BY months;




--6. How does the rental bike usage (cnt) differ between holidays and non-holidays?

WITH holiday_bike_rents AS(
	SELECT (CASE WHEN holiday = 0 THEN 'WORKING-DAY'
			      WHEN holiday = 1 THEN 'HOLIDAY'
			END) holidays,
	   COUNT(holiday) AS count_holidays,
	   SUM(cnt) AS total_bikes_rented
FROM bike_rental.days
GROUP BY holiday) 

/* output of simple form */

SELECT holidays,
       total_bikes_rented,
	   (total_bikes_rented/count_holidays)::NUMERIC AS avg_bike_rented
FROM holiday_bike_rents;


/* finding correlation to get an idea about the variation */

-- SELECT CORR(count_holidays, total_bikes_rented) AS correlation_holi_rents
-- FROM holiday_bike_rents;




--7. Is there a correlation between temperature (temp) and rental bike count (cnt)?


SELECT CORR(temp, cnt) AS corr_btw_temp_rents
FROM bike_rental.days;

/* After manipulation, correlation decreases,
   Though it is more than enough to decide the chage of patterns within the columns
*/

WITH temp_renting AS (
	SELECT FLOOR(41 * temp) AS Temperature, SUM(cnt) AS total_rented_bikes
	FROM bike_rental.days
	GROUP BY FLOOR(41 * temp))

SELECT CORR(Temperature, total_rented_bikes) AS corr_btw_temp_rents
FROM temp_renting;






--8. How does the rental bike usage (cnt) vary across different weather conditions?


SELECT CASE WHEN weathersit = 1 THEN 'Clear, Few clouds, Partly cloudy, Partly cloudy'
		    WHEN weathersit = 2 THEN 'Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist'
		    WHEN weathersit = 3 THEN 'Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds'
		    WHEN weathersit = 4 THEN 'Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog'
		END AS weather_condt,
       SUM(cnt) AS n_bikes_rented
FROM bike_rental.days
GROUP BY weather_condt;




--9. What are the busiest and least busy hours of the day in terms of rental bike usage (cnt)?

WITH most_least_hours AS(
	SELECT hr,
       SUM(cnt) AS n_bikes_rented,
	   RANK() OVER(ORDER BY SUM(cnt) DESC) AS rn
	FROM bike_rental.hours
	GROUP BY hr)

SELECT hr,
       n_bikes_rented
FROM most_least_hours
WHERE rn = (SELECT MIN(rn) FROM most_least_hours)

UNION

SELECT hr,
       n_bikes_rented
FROM most_least_hours
WHERE rn = (SELECT MAX(rn) FROM most_least_hours);




--10. How does the rental bike usage (cnt) differ between weekdays and weekends across different seasons?

SELECT season,
       CASE WHEN weekday = 0 THEN 'WEEKEND'
	        WHEN weekday = 6 THEN 'WEEKEND'
	        ELSE 'WEEKDAY'
	   END AS days,
       SUM(cnt) AS n_bikes_rented
FROM bike_rental.days
GROUP BY season, days
ORDER BY season DESC;




--11. Are there any outliers in the rental bike counts (cnt)? If yes, which factors are associated with them?

/*
  Inter Quartile Range, IQR = percentile_75 - percentile_25,
  Upper_limit = IQR + 1.5 * mean
  Lower_limit = IQR - 1.5 * mean
  Outlier => datapoint > Upper_limit and
             datapoint < Lower_limit
*/
WITH percentile AS (
	SELECT FLOOR(AVG(cnt)) AS mean,
       PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY cnt) AS percentile_75,
	   PERCENTILE_DISC(.25) WITHIN GROUP(ORDER BY cnt) AS percentile_25
	FROM bike_rental.days),
	diff AS (
		SELECT percentile_75 - percentile_25 AS IQR
		FROM percentile
	),
	cal AS (
		SELECT mean + 1.5 * IQR AS upper_limit, 
		       mean - 1.5 * IQR AS lower_limit
		FROM percentile, diff
	)
-- SELECT * FROM cal;
	
SELECT *
FROM bike_rental.days
WHERE cnt > (SELECT upper_limit FROM cal) OR cnt < (SELECT lower_limit FROM cal);




































































































































