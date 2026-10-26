-- Q: Which markets drive sales and profit?
SELECT market,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(sales), 0) AS total_sales,
       ROUND(SUM(order_profit_per_order), 0) AS total_profit,
       ROUND(100.0 * SUM(order_profit_per_order) / SUM(sales), 1) AS profit_margin_pct
FROM orders
WHERE is_canceled = 0
GROUP BY market
ORDER BY total_profit DESC;
