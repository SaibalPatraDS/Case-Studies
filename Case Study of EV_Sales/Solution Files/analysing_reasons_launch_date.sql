/* Analyzing reason for sales decline 1 : Launch date assumption */


/* join the `products` and `sales` table using 'product_id' */

WITH reason_analysis AS (
	SELECT DISTINCT s.product_id, 
		   s.sales_transaction_date,
		   COUNT(s.*) AS total_sales
	FROM ev_sales.products p
	JOIN ev_sales.sales s
	ON s.product_id = p.product_id
	WHERE p.product_id = 7 OR p.product_id = 8
	GROUP BY s.sales_transaction_date, s.product_id
),

cumulative_reason_analysis AS (
	SELECT product_id,
	       sales_transaction_date,
	       total_sales,
	       SUM(total_sales) OVER(PARTITION BY product_id ORDER BY sales_transaction_date
								 ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS cumulative_sales 
	FROM reason_analysis
),

growth_comparison AS(
	    SELECT product_id,
	           sales_transaction_date,
		       total_sales,
	           cumulative_sales,
		       LAG(cumulative_sales,1) OVER(PARTITION BY product_id ORDER BY sales_transaction_date) AS prior_period_sales
		       FROM cumulative_reason_analysis
),

final_cte AS(
	SELECT product_id,
	       sales_transaction_date,
	       cumulative_sales,
	       prior_period_sales,
	       ROUND(100 * (cumulative_sales - prior_period_sales)/prior_period_sales,2) AS percentage_growth
	FROM growth_comparison
)

SELECT * FROM cumulative_reason_analysis;

-- SELECT * FROM final_cte
-- WHERE product_id = 8;
-- SELECT * FROM growth_comparison
-- WHERE product_id = 8;






























































































