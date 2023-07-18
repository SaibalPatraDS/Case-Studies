# Zomato Data Analysis

This repository contains SQL queries and analysis performed on the Zomato dataset. The dataset consists of information about customer orders, products, user details, and gold user signups. The SQL queries provided analyze various aspects of the dataset and provide insights into customer behavior and preferences.

## Queries and Analysis

1. **Total Amount Spent by Each Customer on Zomato**
   - Merges the `products` and `sales` tables on the `product_id` column.
   - Calculates the total amount spent by each customer using the `SUM` function and groups the results by `user_id`.
   - Returns the user ID and the total amount spent.

2. **Number of Days Each Customer Visited Zomato**
   - Counts the number of visits made by each customer using the `COUNT` function and grouping the results by `user_id`.
   - Returns the user ID and the count of visits.

3. **First Product Purchased by Each Customer**
   - Merges the `products` and `sales` tables on the `product_id` column.
   - Ranks the products based on the order date for each user.
   - Returns the user ID and the name of the first product purchased by each customer.

4. **Most Purchased Item on the Menu and its Total Purchase Count**
   - Counts the total number of purchases for each product based on `user_id` and `product_id`.
   - Ranks the products based on the total purchase count for each user.
   - Returns the user ID, the most purchased product's name, and the total number of purchases.

5. **Most Popular Item for Each Customer**
   - Counts the total number of purchases for each product based on `user_id` and `product_id`.
   - Ranks the products based on the total purchase count for each user.
   - Returns the user ID and the name of the most popular product for each customer.

6. **First Item Purchased by a Customer After Becoming a Member**
   - Merges the `goldusers_signup` table with the `sales` table on the `user_id` column.
   - Merges the resulting table with the `products` table on the `product_id` column.
   - Filters the results to include only orders placed after the customer's signup date.
   - Ranks the products based on the order date for each user.
   - Returns the user ID and the name of the first product purchased by each customer after becoming a member.

7. **Last Item Purchased by a Customer Before Becoming a Member**
   - Merges the `goldusers_signup` table with the `sales` table on the `user_id` column.
   - Merges the resulting table with the `products` table on the `product_id` column.
   - Filters the results to include only orders placed before the customer's signup date.
   - Ranks the products based on the order date (in descending order) for each user.
   - Returns the user ID and the name of the last product purchased by each customer before becoming a member.

8. **Total Orders and Amount Spent for Each Member Before They Become a Member**
   - Selects only gold users.
   - Joins the `sales` and `goldusers_signup` tables on the `user_id` column, considering only transactions where the order date is before the signup date.
   - Counts the total number of products and calculates the total amount spent for each user.
   - Returns the user ID, the total number of products, and the total amount spent.

9. **Points Collected by Each Customer and Most Points Given for a Product**
   - Calculates the total points collected by each customer based on the purchase amount and the conversion rate for each product.
   - Ranks the products based on the total points collected for each user.
   - Returns the user ID, the product ID, the total collected points, and the total points for each user.

10. **Zomato Points Earned in the First Year After Joining the Gold Program**
    - Merges the `goldusers_signup` and `sales` tables on the `user_id` column.
    - Filters the purchases that occurred within one year of joining the gold program.
    - Joins the resulting table with the `products` table on the `product_id` column.
    - Calculates the total zomato points earned based on the purchase amount and the conversion rate.
    - Determines which user earned more zomato points and the total zomato points earned in the first year.

11. **Ranking of All Transactions for Each Customer**
    - Uses the rank function to rank all transactions for each customer.
    - Retrieves the user ID, product name, purchase date, and the rank of each transaction.

12. **Ranking of Transactions for Each Member During Gold Membership**
    - Selects all transactions made by customers.
    - Ranks only the transactions where the order date is after the signup date as "G" (gold member) and transactions where the order date is before the signup date as "NG" (non-gold member). Non-gold member transactions are marked as "na".
    - Merges the `goldusers_signup`, `users`, and `sales` tables on the `user_id` column.
    - Ranks the transactions based on the order date using CASE WHEN statements.
    - Returns the user ID, transaction date, transaction category, and the rank of each transaction.

## Dataset
The dataset used for analysis consists of the following tables:

- `products`: Contains information about the products available on Zomato, including the product ID, name, and price.
- `sales`: Stores details about customer orders, including the user ID, product ID, and order date.
- `users`: Provides information about the users, such as their ID and other details.
- `goldusers_signup`: Contains data about the users who have signed up for the gold membership, including the user ID, signup date, and membership status.

Please refer to the actual database for more detailed information about the table structures and additional columns.

## Usage
To run the SQL queries and perform the analysis, you need access to a PostgreSQL database that contains the Zomato dataset. Execute the queries in the order listed in the "Queries and Analysis" section to obtain the desired results.

Feel free to modify the queries or adapt them to other SQL database systems as needed.

## Blog Post 
If you want to read the detailed blog on this case study, you can read here [medium](https://saibalpatra.medium.com/analyzing-customer-behavior-and-preferences-on-zomato-c8360c3d34bc)

## License
The code and analysis provided in this repository are available under the [GPL-3.0 license](https://github.com/SaibalPatraDS/Case-Studies/blob/main/LICENSE).

## Acknowledgments
The Zomato dataset used in this analysis is a fictional dataset created for educational purposes. The queries and analysis in this repository were performed solely for demonstration and learning purposes.
