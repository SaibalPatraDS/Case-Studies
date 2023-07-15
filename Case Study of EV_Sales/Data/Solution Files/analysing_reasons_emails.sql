/* -- Email Analysis */

/*

This assessment will provide insights into how well the campaign engages recipients, whether they open the emails, 
and if they click on the provided links, helping to measure the overall impact and success of the campaign.

Additionally, it is essential to consider the following assumptions when conducting this analysis:

--- Collect email campaign-related data specifically for Sprint scooters.

--- Include data from the period of 2 months before the sprint model launch, 
    as the digital marketing campaign started only 2 months before the launch.

--- Connect the two data sets considering that a single customer may have received multiple emails for different products during the campaign.

    To calculate the Click Rate, Refer to the following formula:

            Click Rate = ( E-mails Clicked ) / ( E-mail sent - Bounced )

Prepare the summary table that shows the comparison between the calculated email opening rate & Click Rate against the benchmark rates. 
Typically the industry benchmark for a quality campaign is an 18% email opening rate and an 8% Click Rate

*/



/*
  Join the emails and sales using customer_id and condition given, product_id = 7 for 'Sprint Scooter'
*/

WITH sprint_emails AS (
	SELECT e.customer_id,
	       e.opened,
	       e.bounced,
	       e.clicked,
	       e.sent_date,
	       e.opened_date,
	       e.clicked_date
	FROM ev_sales.emails e
	JOIN ev_sales.sales s
	ON e.customer_id = s.customer_id),
	
modify_emails AS(
	SELECT customer_id, 
	       CASE WHEN opened = 'f' THEN 0 ELSE 1 END AS opens,
	       CASE WHEN clicked = 'f' THEN 0 ELSE 1 END AS click,
	       CASE WHEN bounced = 'f' THEN 0 ELSE 1 END AS bounce,
	       opened_date, clicked_date, sent_date
	FROM sprint_emails
),
	
-- SELECT * FROM sprint_emails;
cte AS (
	SELECT customer_id,
       SUM(click) AS click_data,
	   SUM(bounce) AS bounce_data,
	   COUNT(sent_date) AS n_sent
	FROM modify_emails
	WHERE sent_date > '2016-09-01' 
		  and sent_date < '2016-10-31' 
	GROUP BY customer_id
	ORDER BY customer_id)

-- SELECT SUM(click_data) AS total_clicked,
--        SUM(bounce_data) AS total_bounce,
-- 	   SUM(n_sent) AS total_sent
-- FROM cte;

SELECT 100 * SUM(click_data)/(SUM(n_sent) - SUM(bounce_data)) AS click_rate
FROM cte;






































































































