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

## Dataset
The dataset used for analysis consists of the following tables:

- `products`: Contains information about the products available on Zomato, including the product ID and price.
- `sales`: Stores details about customer orders, including the user ID, product ID, and order date.
- `users`: Provides information about the users, such as their ID, name, and contact details.
- `goldusers_signup`: Contains data about the users who have signed up for the gold membership, including the user ID, signup date, and membership status.

Please refer to the actual database for more detailed information about the table structures and additional columns.

## Usage
To run the SQL queries and perform the analysis, you need access to a PostgreSQL database that contains the Zomato dataset. Execute the queries in the order listed in the "Queries and Analysis" section to obtain the desired results.

Feel free to modify the queries or adapt them to other SQL database systems as needed.

## License
The code and analysis provided in this repository are available under the [MIT License](LICENSE).

## Acknowledgments
The Zomato dataset used in this analysis is a fictional dataset created for educational purposes. The queries and analysis in this repository were performed solely for demonstration and learning purposes.
