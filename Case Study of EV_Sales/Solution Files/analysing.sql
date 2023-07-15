/* Quantifying the sales drop */


/* Problem Statement */

/* Examine the calculated sales growth percentage to determine if it is negative or shows a decline.
   This confirms that sales have indeed decreased.
*/

WITH sales_growth AS (
		SELECT sales_transaction_date,
		   COUNT(*) AS total_transactions
	FROM ev_sales.sales
	WHERE sales_transaction_date >= '2016-10-10' 
	GROUP BY sales_transaction_date
	ORDER BY sales_transaction_date),
 
    cum_sales_growth AS (
	SELECT sales_transaction_date,
		   total_transactions,
		   SUM(total_transactions) OVER(ORDER BY sales_transaction_date
									   ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS cumulative_sum
	FROM sales_growth),
    
	percent_sales_growth AS(
		SELECT sales_transaction_date,
		       total_transactions,
		       LAG(cumulative_sum,1,0) OVER(ORDER BY sales_transaction_date) AS prior_period_sales,
		       ROUND(100 * (total_transactions - LAG(cumulative_sum,1,0) OVER(ORDER BY sales_transaction_date))/LAG(cumulative_sum,1) OVER(ORDER BY sales_transaction_date),0) AS percentage_growth
		FROM cum_sales_growth
	)
    
SELECT * FROM percent_sales_growth;


/* Visualization of the results in the form of line chart is sufficient enough to make sure that sales are declining */























