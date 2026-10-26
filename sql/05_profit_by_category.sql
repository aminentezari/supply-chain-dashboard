-- Q: Which product categories drive profit?
SELECT category_name,
       ROUND(SUM(sales), 0) AS total_sales,
       ROUND(SUM(order_profit_per_order), 0) AS total_profit,
       ROUND(100.0 * SUM(order_profit_per_order) / SUM(sales), 1) AS margin_pct
FROM orders
WHERE is_canceled = 0
GROUP BY category_name
ORDER BY total_profit DESC;