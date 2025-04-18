##1. Total orders completed on 2023‑03‑18

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM sales
WHERE date = '2023-03-18';


##2. Total orders on 2023‑03‑18 by John Doe

SELECT COUNT(DISTINCT s.order_id) AS total_orders
FROM sales AS s
JOIN customers AS c
ON s.customer_id = c.customer_id
Where s.date = '2023-03-19'
AND c.first_name = 'John'
AND c.last_name = 'Doe'; 


##3. Number of customers who purchased in Jan 2023 and their avg spend


SELECT
  COUNT(*) AS total_customers,
  AVG(customer_total) AS avg_spend_per_customer
FROM (
    SELECT
        customer_id,
        SUM(revenue) AS customer_total
    FROM sales
    WHERE date >= '2023-01-01'
        AND date < '2023-02-01'
    GROUP BY customer_id
) AS sub;

4. Departments with < $600 revenue in 2022

SELECT
  i.department
FROM sales AS s
JOIN items AS i
  ON s.item_id = i.item_id
WHERE s.date >= '2022-01-01'
  AND s.date <  '2023-01-01'
GROUP BY i.department
HAVING SUM(s.revenue) < 600;


5. Highest and lowest single‑order revenue

  MAX(order_total) AS max_revenue,
  MIN(order_total) AS min_revenue
FROM (
  SELECT
    order_id,
    SUM(revenue) AS order_total
  FROM sales
  GROUP BY order_id
) AS t;


6. Line‐items in the single most‑lucrative order

WITH best AS (
  SELECT
    order_id
  FROM (
    SELECT
      order_id,
      SUM(revenue) AS order_total
    FROM sales
    GROUP BY order_id
  ) AS sums
  ORDER BY order_total DESC
  LIMIT 1
)
SELECT
  s.order_id,
  s.item_id,
  i.item_name,
  s.quantity,
  s.revenue
FROM sales AS s
JOIN best       AS b ON s.order_id = b.order_id
JOIN items      AS i ON s.item_id  = i.item_id;