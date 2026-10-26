-- Q: Which categories make 80% of profit? (A = up to 80%, B = up to 95%, C = rest)
WITH cat AS (
    SELECT category_name,
           SUM(sales) AS total_sales,
           SUM(order_profit_per_order) AS total_profit
    FROM orders
    WHERE is_canceled = 0
    GROUP BY category_name
),
ranked AS (
    SELECT *,
           SUM(total_profit) OVER (ORDER BY total_profit DESC) AS running_profit,
           SUM(total_profit) OVER () AS grand_profit
    FROM cat
)
SELECT category_name,
       ROUND(total_sales, 0) AS total_sales,
       ROUND(total_profit, 0) AS total_profit,
       ROUND(100.0 * running_profit / grand_profit, 1) AS cumulative_pct,
       CASE WHEN 100.0 * (running_profit - total_profit) / grand_profit < 80 THEN 'A'
            WHEN 100.0 * (running_profit - total_profit) / grand_profit < 95 THEN 'B'
            ELSE 'C' END AS abc_class
FROM ranked
ORDER BY total_profit DESC;